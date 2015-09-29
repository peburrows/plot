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
# {:book, "/books.json"}
# if you need to call a different URL for user->books than books

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

```elixir
defmodule UserResolver do
  def resolver(%Plot.Object{name: "user"}, parent, args \\ [])
end
```
