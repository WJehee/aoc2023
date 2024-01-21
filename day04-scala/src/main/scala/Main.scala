import scala.io.Source

@main def hello: Unit =

  val filename = "input.txt"
  val lines = Source.fromFile(filename).getLines.toList
  val result1 = lines
    .map(process_line)
    .map(sol1)
    .fold(0)((x, y) => x + y)
  println("Result 1:")
  println(result1)

  val result2 = sol2(lines, lines)
  println("Result 2:")
  println(result2)


def process_line(line: String): (Array[Int], Array[Int]) =
  val processed_line = line.dropWhile((char: Char) => char != ':').drop(2)
  val winning = processed_line
    .takeWhile((char: Char) => char != '|')
    .split(' ')
    .filter(_ != "")
    .map(_.toInt)
  val numbers = processed_line
    .dropWhile((char: Char) => char != '|')
    .drop(2)
    .split(' ')
    .filter(_ != "")
    .map(_.toInt)
  (winning, numbers)

def sol1(winning: Array[Int], numbers: Array[Int]) =
  val intersection = winning.intersect(numbers)
  intersection.length match {
    case 0 => 0
    case x => intersection.fold(1)((x, _) => x * 2) / 2
  }

def sol2(og_lines: List[String], lines: List[String]): Int = 
  lines
    .map((line) => {
      val (w: Array[Int], n: Array[Int]) = process_line(line)
      val tickets = w.intersect(n).length

      val next = og_lines 
        .dropWhile(x => x != line)
        .drop(1)
        .take(tickets)
      1 + sol2(og_lines, next)
    })
    .fold(0)((x, y) => x + y)

