name := "codejam"

version := "0.1"

scalaVersion := "2.10.1"

scalacOptions ++= Seq("-deprecation", "-feature", "-Xelide-below", "900")

javacOptions ++= Seq("-Xlint:unchecked")

libraryDependencies += "com.google.guava" % "guava" % "14.0.1"

libraryDependencies += "junit" % "junit" % "4.11" % "test"

libraryDependencies += "org.scalatest" %% "scalatest" % "1.9.1" % "test"
