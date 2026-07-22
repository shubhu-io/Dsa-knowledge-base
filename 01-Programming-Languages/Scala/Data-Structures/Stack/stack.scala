class Stack[T] {
  private var items: List[T] = List()

  def push(item: T): Unit = {
    items = item :: items
  }

  def pop(): Option[T] = {
    items match {
      case Nil => None
      case head :: tail =>
        items = tail
        Some(head)
    }
  }

  def peek(): Option[T] = items.headOption

  def isEmpty: Boolean = items.isEmpty

  def size: Int = items.length
}

object StackApp extends App {
  val stack = new Stack[Int]()
  stack.push(1)
  stack.push(2)
  stack.push(3)

  println(s"Stack size: ${stack.size}")
  println(s"Popped: ${stack.pop().getOrElse("empty")}")
  println(s"Top: ${stack.peek().getOrElse("empty")}")
}