package dotfiles

import dotfiles.dsl.*

import java.nio.file.Paths
import org.atnos.eff.*
import org.atnos.eff.syntax.all.*

@main def run(): Unit = {

  type Stack = Fx.fx2[ShellCommand, Either[ExecError, *]]

  def program[R: _shell: _errorEither]: Eff[R, Seq[String]] = for {
    directories <- ShellCommand.ls(Paths.get("."))
  } yield directories

  val result = ShellCommandInterpreter
    .runShellCommand(program[Stack])
    .runEither
    .run

  println(result)
}
