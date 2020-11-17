{-# LANGUAGE QuasiQuotes #-}

module GACC.BuildDir where

import Control.Monad.Reader (MonadReader)
import Lens.Micro (Lens', lens)
import Lens.Micro.Mtl (view)
import Path (Dir, Path, Rel, reldir)
import qualified Path

newtype BuildDir = BuildDir {unBuildDir :: Path Rel Dir}

class HasBuildDir env where
  buildDirL :: Lens' env BuildDir

instance HasBuildDir BuildDir where
  buildDirL = lens id (const id)

getDefault :: BuildDir
getDefault = BuildDir [reldir|_build|]

buildDirFilePath :: (MonadReader env m, HasBuildDir env) => m FilePath
buildDirFilePath = Path.fromRelDir . unBuildDir <$> view buildDirL
