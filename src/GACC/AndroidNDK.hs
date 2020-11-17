{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes #-}

module GACC.AndroidNDK where

import Control.Exception.Extra (Partial)
import Control.Monad.Reader (MonadReader)
import Data.Maybe (fromJust)
import Data.Text (Text)
import qualified Data.Text as Text
import Development.Shake.Plus (MonadRules, (%>))
import qualified Development.Shake.Plus as SP
import GACC.BuildDir (HasBuildDir)
import qualified GACC.BuildDir as BuildDir
import Lens.Micro (Lens', lens)
import Lens.Micro.Mtl (view)
import Path (Dir, File, Path, Rel, relfile, (</>))
import qualified Path

newtype NDKVersion = NDKVersion {unNDKVersion :: Text}

class HasNDKVersion env where
  ndkVersionL :: Lens' env NDKVersion

instance HasNDKVersion NDKVersion where
  ndkVersionL = lens id (const id)

-- | Build action to require the Android Native Development Kit.
requireNDK ::
  ( Partial,
    MonadReader env m,
    MonadRules m,
    HasBuildDir env,
    HasNDKVersion env
  ) =>
  m ()
requireNDK = do
  buildDir <- Path.fromRelDir . BuildDir.unBuildDir <$> view BuildDir.buildDirL
  url <- Text.unpack <$> ndkUrl
  ndkNoticeFile <- noticeFile
  SP.wantP [ndkNoticeFile]
  Path.fromRelFile ndkNoticeFile %> \_ ->
    SP.command_
      [SP.Shell]
      ("curl -L " <> url <> " | tar x -C " <> buildDir)
      []

-- | The NDK download URL.
ndkUrl :: (MonadReader env m, HasNDKVersion env) => m Text
ndkUrl = do
  ver <- unNDKVersion <$> view ndkVersionL
  let repo = "https://dl.google.com/android/repository/"
  pure $ repo <> "android-ndk-" <> ver <> "-darwin-x86_64.zip"

-- | The NOTICE file inside an unpacked Android NDK distribution.
noticeFile :: (MonadReader env m, HasBuildDir env, HasNDKVersion env) => m (Path Rel File)
noticeFile = do
  buildDir <- BuildDir.unBuildDir <$> view BuildDir.buildDirL
  ndk <- ndkDir
  pure $ buildDir </> ndk </> [relfile|NOTICE|]

-- | The NDK directory.
ndkDir :: (MonadReader env m, HasNDKVersion env) => m (Path Rel Dir)
ndkDir = do
  ndkVersionString <- Text.unpack . unNDKVersion <$> view ndkVersionL
  pure . fromJust . Path.parseRelDir $ "android-ndk-" <> ndkVersionString
