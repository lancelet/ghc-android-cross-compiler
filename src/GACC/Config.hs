{-# LANGUAGE OverloadedStrings #-}

module GACC.Config where

import GACC.AndroidNDK (HasNDKVersion)
import qualified GACC.AndroidNDK as AndroidNDK
import GACC.BuildDir (BuildDir, HasBuildDir)
import qualified GACC.BuildDir as BuildDir
import Lens.Micro (Lens', lens)

data Config = Config
  { buildDir :: BuildDir,
    ndkVersion :: AndroidNDK.NDKVersion
  }

class HasConfig env where
  configL :: Lens' env Config

instance HasConfig Config where
  configL = lens id (const id)

instance HasBuildDir Config where
  buildDirL = lens buildDir (\config d -> config {buildDir = d})

instance HasNDKVersion Config where
  ndkVersionL = lens ndkVersion (\config v -> config {ndkVersion = v})

getDefault :: IO Config
getDefault = do
  pure $
    Config
      { buildDir = BuildDir.getDefault,
        ndkVersion = AndroidNDK.NDKVersion "r21d"
      }
