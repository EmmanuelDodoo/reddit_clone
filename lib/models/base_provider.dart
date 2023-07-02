/// Exception thrown when a provider can no longer produce a post
class EndOfProvider implements Exception {}

/// Exception thrown when a provider does not contain a particular item
class NotFound implements Exception {}

/// Class for a node in a linked list
class _Node<T> {
  /// The data being carried on this node. Is immutable
  late final T data;

  /// The previous node in this list. May be null
  _Node<T>? previous;

  /// The next node in this list. May be null
  _Node<T>? next;

  _Node({required this.data, this.previous, this.next});
}

///Class for a data provider
///Implements a way to keep track of a sequence of data
class DataProvider<T> {
  /// The current node in the sequence
  late _Node<T> _current;

  /// Retrieve the current item of this sequence
  T getCurrent() => _current.data;

  /// The beginning node of this sequence
  late _Node<T> _head;

  /// Retrieve the first item of this sequence
  T getHead() => _head.data;

  /// The last node of this sequence
  late _Node<T> _tail;

  ///Retrieve the last item of this sequence
  T getTail() => _tail.data;

  /// The number of items in this sequence
  int _length = 0;

  int getLength() => _length;

  /// Initialise a new provider with a single item in the sequence
  DataProvider.fromSingle({required T item}) {
    _Node<T> temp = _Node(data: item);
    _current = temp;
    _head = temp;
    _tail = temp;
    _length++;
  }

  /// Initialise a new provider from a list of items. Both the head and current
  /// are set to the first element in the list.
  DataProvider.fromList({required List<T> itemList}) {
    itemList.fold(0, (previousValue, element) {
      _Node<T> temp = _Node(data: element);
      if (previousValue == 0) {
        _head = temp;
        _current = temp;
        _tail = temp;
        _length++;
        return previousValue + 1;
      }
      _tail.next = temp;
      temp.previous = _tail;
      _tail = temp;
      _length++;
      return previousValue + 1;
    });
  }

  /// Attempts to move to the next item in the sequence.
  ///
  /// Returns the new current item if successful.
  ///
  /// Raises an `EndOfProvider` if there are no next items
  T next() {
    if (_current.next != null) {
      _current = _current.next!;
      return _current.data;
    }
    throw EndOfProvider();
  }

  /// Attempts to move back to the previous item in the sequence.
  ///
  /// Returns the new current item if successful.
  ///
  /// Raises an `EndOfProvider` if unsuccessful.
  T previous() {
    if (_current.previous != null) {
      _current = _current.previous!;
      return _current.data;
    }
    throw EndOfProvider();
  }

  /// Adds all items in `newItems` to the end of the sequence.
  ///
  /// Requires the sequence to be non-empty
  ///
  /// Returns true if successful
  bool add({required List<T> newItems}) {
    for (T element in newItems) {
      _Node<T> temp = _Node(data: element);
      _tail.next = temp;
      temp.previous = _tail;
      _tail = temp;
      _length++;
    }
    return true;
  }

  /// Maps the function `f` on all items in the current sequence.
  ///
  /// Returns a new provider with the resultant items in order.
  ///
  /// Requires this sequence is not empty
  DataProvider<E> map<E>(E Function(T) f) {
    _Node<T>? temp = _head;
    List<E> resultantList = [];

    while (temp != null) {
      E res = f(temp.data);
      resultantList.add(res);

      temp = temp.next;
    }

    return DataProvider.fromList(itemList: resultantList);
  }

  /// Return the first item which satisfies the predicate `f`
  /// Raises `NotFound` if the item cannot be found
  ///
  /// Requires: the sequence is not empty
  T find(bool Function(T) f) {
    _Node<T>? temp = _head;

    while (temp != null) {
      if (f(temp.data)) {
        return temp.data;
      }
      temp = temp.next;
    }

    throw NotFound();
  }

  /// Modifies the provider to point the first item that satisfies the predicate
  /// `f` as the current item. Nothing is changed if no item satisfies the `f`
  ///
  /// Returns true if successful
  ///
  /// Requires the sequence is not empty
  bool moveToItem(bool Function(T) f) {
    _Node<T>? temp = _head;

    while (temp != null) {
      if (f(temp.data)) {
        _current = temp;
        return true;
      }
      temp = temp.next;
    }

    return false;
  }
}
