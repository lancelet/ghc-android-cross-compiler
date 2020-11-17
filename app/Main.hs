{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes #-}

module Main where

import Control.Monad.IO.Class (liftIO)
import Control.Monad.Reader (runReaderT)
import Data.Functor.Identity (runIdentity)
import qualified Development.Shake.Plus as SP
import GACC.AndroidNDK (HasNDKVersion)
import qualified GACC.AndroidNDK as AndroidNDK
import GACC.BuildDir (HasBuildDir)
import qualified GACC.BuildDir as BuildDir
import GACC.Config (Config, HasConfig)
import qualified GACC.Config as Config
import Lens.Micro (lens)
import Path (Dir, Rel, reldir)

main :: IO ()
main = do
  config <- Config.getDefault

  let env = Env {envConfig = config}
      shakeOpts =
        runIdentity $
          flip runReaderT env $ do
            buildDir <- BuildDir.buildDirFilePath
            pure $ SP.shakeOptions {SP.shakeFiles = buildDir}

  SP.shakeArgs shakeOpts $
    SP.runShakePlus env $ do
      SP.phony "clean" $ do
        liftIO $ putStrLn "Cleaning files in _build"
        SP.removeFilesAfter [reldir|_build|] ["//*"]

      AndroidNDK.requireNDK

newtype Env = Env
  {envConfig :: Config}

instance HasConfig Env where
  configL = lens envConfig (\env c -> env {envConfig = c})

instance HasBuildDir Env where
  buildDirL = Config.configL . BuildDir.buildDirL

instance HasNDKVersion Env where
  ndkVersionL = Config.configL . AndroidNDK.ndkVersionL
