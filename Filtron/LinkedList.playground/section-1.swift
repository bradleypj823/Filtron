import UIKit

class Node <T>
{
    var value: T?
    var next: Node?
}

class LinkedList <T>
{
    var head: Node <T>?
    
    func insert(value: T)
    {
        if head == nil
        {
            var node = Node<T>()
            node.value = value
            node.next = nil
            head = node
            return
        }
        
        var currentNode = head
        while currentNode?.next != nil
        {
            currentNode = currentNode?.next
        }
        
        var node = Node<T>()
        node.value = value
        node.next = nil
        
        currentNode?.next = node
    }
}