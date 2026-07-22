class Node(val value: Int) {
  var next: Option[Node] = None
}

class LinkedList {
  private var head: Option[Node] = None

  def append(value: Int): Unit = {
    val newNode = new Node(value)
    head match {
      case None => head = Some(newNode)
      case Some(h) =>
        var current = h
        while (current.next.isDefined) {
          current = current.next.get
        }
        current.next = Some(newNode)
    }
  }

  def prepend(value: Int): Unit = {
    val newNode = new Node(value)
    newNode.next = head
    head = Some(newNode)
  }

  def delete(value: Int): Unit = {
    head match {
      case None => return
      case Some(h) if h.value == value =>
        head = h.next
        return
      case _ =>
    }

    var current = head.get
    while (current.next.isDefined && current.next.get.value != value) {
      current = current.next.get
    }
    if (current.next.isDefined) {
      current.next = current.next.get.next
    }
  }

  def display(): Unit = {
    var current = head
    while (current.isDefined) {
      print(s"${current.get.value} -> ")
      current = current.get.next
    }
    println("null")
  }
}

object LinkedListApp extends App {
  val list = new LinkedList()
  list.append(1)
  list.append(2)
  list.append(3)
  list.prepend(0)

  println("List:")
  list.display()

  list.delete(2)
  println("After deleting 2:")
  list.display()
}