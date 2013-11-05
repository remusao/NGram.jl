# NGram

## Linear interpolation

This implementation uses the linear interpolation to build the model. For example, with a simple trigram model

```haskell
p("book" | "the", "green") = count("the green book") / count("the green")
```
But there are some limitations

* We need a bigger corpus to efficiently train a trigram model compared to bigram or unigram
* Count(trigram) is often equal to zero
* With bigram or unigram we don't capture as much information

The idea is then to combine the results of `trigram` with `bigram` and `unigram`. We can generalize by
saying that to compute ngram, we also use the results of `(n-1)gram`, ..., `bigram`, `unigram`.
Here is an exemple in the case of a trigram model.


```haskell
p("book" | "the", "green") = a * count("the green book") / count("the green")
                          +  b * count("the green") / count("the")
                          +  c * count("the") / count()
    where
        a + b + c = 1
        a >= 0
        b >= 0
        c >= 0

# For example: a = b = c = 1 / 3
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
