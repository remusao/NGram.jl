# NGram

## Linear interpolation

This implementation uses the linear interpolation to build the model. For
example, with the trigram model, if we want to compute `p(book | the, green)`,
instead of juste computing `count("the green book") / count("the green")`, we
also use information from `unigram` and `bigram` to smooth the results

```
p(book | the, green) = a * count("the green book") / count("the green")
                    +  b * count("the green") / count("the")
                    +  c * count("the") / count()

where a + b + c = 1 and a >= 0, b >= 0, c >= 0
```

## Example

```julia
using NGram

texts = String["the green book", "my blue book", "his green house", "book"]

# Train a trigram model on the documents
model = NGramModel(texts, 3)

# Query on the model
# p(book | the, green)
model["the green book"]
```
