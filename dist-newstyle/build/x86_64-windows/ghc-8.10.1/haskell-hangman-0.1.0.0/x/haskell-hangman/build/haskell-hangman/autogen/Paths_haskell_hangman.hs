{-# LANGUAGE CPP #-}
{-# LANGUAGE NoRebindableSyntax #-}
{-# OPTIONS_GHC -fno-warn-missing-import-lists #-}
module Paths_haskell_hangman (
    version,
    getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir,
    getDataFileName, getSysconfDir
  ) where

import qualified Control.Exception as Exception
import Data.Version (Version(..))
import System.Environment (getEnv)
import Prelude

#if defined(VERSION_base)

#if MIN_VERSION_base(4,0,0)
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#else
catchIO :: IO a -> (Exception.Exception -> IO a) -> IO a
#endif

#else
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#endif
catchIO = Exception.catch

version :: Version
version = Version [0,1,0,0] []
bindir, libdir, dynlibdir, datadir, libexecdir, sysconfdir :: FilePath

bindir     = "C:\\Users\\matth\\AppData\\Roaming\\cabal\\bin"
libdir     = "C:\\Users\\matth\\AppData\\Roaming\\cabal\\x86_64-windows-ghc-8.10.1\\haskell-hangman-0.1.0.0-inplace-haskell-hangman"
dynlibdir  = "C:\\Users\\matth\\AppData\\Roaming\\cabal\\x86_64-windows-ghc-8.10.1"
datadir    = "C:\\Users\\matth\\AppData\\Roaming\\cabal\\x86_64-windows-ghc-8.10.1\\haskell-hangman-0.1.0.0"
libexecdir = "C:\\Users\\matth\\AppData\\Roaming\\cabal\\haskell-hangman-0.1.0.0-inplace-haskell-hangman\\x86_64-windows-ghc-8.10.1\\haskell-hangman-0.1.0.0"
sysconfdir = "C:\\Users\\matth\\AppData\\Roaming\\cabal\\etc"

getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath
getBinDir = catchIO (getEnv "haskell_hangman_bindir") (\_ -> return bindir)
getLibDir = catchIO (getEnv "haskell_hangman_libdir") (\_ -> return libdir)
getDynLibDir = catchIO (getEnv "haskell_hangman_dynlibdir") (\_ -> return dynlibdir)
getDataDir = catchIO (getEnv "haskell_hangman_datadir") (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "haskell_hangman_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "haskell_hangman_sysconfdir") (\_ -> return sysconfdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "\\" ++ name)
