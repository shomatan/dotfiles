ThisBuild / version := "0.1.0-SNAPSHOT"

ThisBuild / scalaVersion := "3.1.2"

lazy val root = (project in file("."))
  .settings(
    name := "dotfiles"
  )

nativeImageInstalled := true
nativeImageOptions ++= List(
  "--no-fallback"
//  "--link-at-build-time"
)

enablePlugins(NativeImagePlugin)

Global / onChangedBuildSource := ReloadOnSourceChanges
