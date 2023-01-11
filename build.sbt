ThisBuild / version := "0.1.0-SNAPSHOT"

ThisBuild / scalaVersion := "3.2.1"

lazy val root = (project in file("."))
  .settings(
    name := "dotfiles",
    scalacOptions ++= Seq(
      "-feature",
      "-unchecked",
      "-Ykind-projector",
      "-language:postfixOps"
    ),
    libraryDependencies ++= Seq(
      "org.atnos" %% "eff" % "6.0.0"
    )
  )

Global / onChangedBuildSource := ReloadOnSourceChanges
