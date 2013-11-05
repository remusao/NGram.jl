# NGram

```julia
using NGram

texts = String["the green book", "my blue book", "his green house", "book"]

# Train a trigram model on the documents
model = NGramModel(texts, 3)

# Query on the model
# P(book | the, green)
model["the green book"]
```
