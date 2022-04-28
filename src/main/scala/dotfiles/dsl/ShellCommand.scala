package dotfiles.dsl

import org.atnos.eff.*
import org.atnos.eff.Interpret.translate
import org.atnos.eff.either.fromEither
import org.atnos.eff.EitherImplicits.errorTranslate
import org.atnos.eff.either.errorTranslate
import org.atnos.eff.Members.extractMember

import java.nio.file.Path

sealed trait ShellCommand[+A]
case class ListSegments(path: Path) extends ShellCommand[Seq[String]]

type _shell[R] = ShellCommand |= R
type _errorEither[R] = Either[ExecError, *] |= R

object ShellCommand {
  def ls[R: _shell](path: Path): Eff[R, Seq[String]] =
    Eff.send[ShellCommand, R, Seq[String]](ListSegments(path))
}

case class ExecError(result: Int, err: Seq[String])

object ShellCommandInterpreter {

  def runShellCommand[R, U, A](
      effects: Eff[R, A]
  )(implicit
      m: Member.Aux[ShellCommand, R, U],
      throwable: _errorEither[U]
  ): Eff[U, A] = {
    translate(effects)(new Translate[ShellCommand, U] {
      def apply[X](cmd: ShellCommand[X]): Eff[U, X] = {
        cmd match {
          case ListSegments(path) =>
            fromEither(
              exec(Seq("ls", path.toAbsolutePath.toString))
            )
        }
      }
    })
  }

  private def exec(cmd: Seq[String]): Either[ExecError, Seq[String]] = {
    import scala.collection.mutable._
    import scala.sys.process._

    val out = ArrayBuffer[String]()
    val err = ArrayBuffer[String]()

    val logger = ProcessLogger((o: String) => out += o, (e: String) => err += e)

    val r = Process(cmd) ! logger

    if (err.isEmpty)
      Right(out.toSeq)
    else
      Left(ExecError(r, err.toSeq))
  }
}
