Given the following GraphQL query
```
query userWithBooks {
  user {
    firstName,
    lastName,
    eulaAcceptedAt,
    books {
      title,
      author,
      expirationDate
    }
  }
}
```

We need some way to map to the backend JSON

# %{books: "/books.json"}
# if you need to call a different URL for user->books than books
# %{user:  "/user.json", books: "/user/books.json"}

type User {
  firstName: String
  lastName:  String
  eulaAcceptedAt: String
  books(order: String, limit: Int, page: Int): [Book]
  highlights(isbn: String!): [Highlight]
}

type Book {
  title: String
  author: String
  expirationDate: String
}

type Highlight {
  isbn: String!
  selectedText: String
  cfi: String
}