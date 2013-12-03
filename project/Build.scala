import sbt._
import Keys._
import play.Project._

object ApplicationBuild extends Build {

  val appName         = "gema"
  val appVersion      = "1.0-SNAPSHOT"

  val appDependencies = Seq(
    // Add your project dependencies here,
    javaCore,
    javaJdbc,
    javaEbean,
    "commons-collections" % "commons-collections" % "3.2.1",
    "commons-lang" % "commons-lang" % "2.6",
    "mysql" % "mysql-connector-java" % "5.1.26",
    "jasperreports" % "jasperreports" % "3.5.3"
  )

  val main = play.Project(appName, appVersion, appDependencies).settings(
    ebeanEnabled := true
  )

}
