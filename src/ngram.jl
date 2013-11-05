

immutable NGramModel
    ml::Dict{UTF8String, Float64}
    n::Integer
end

getindex(m::NGramModel, gram::String) = get(m.ml, utf8(gram), 0.0)

function NGramModel(sentences::Vector{String}, n)

    # Tokenize string
    tokenize(s) = TextAnalysis.tokenize(TextAnalysis.EnglishLanguage, s)

    # NGramize tokens
    function ngramize(words)
        # Use "*" symbol start and "STOP" for end of sentence
        words = vcat("*", "*", words, "STOP")
        n_words = length(words)
        tokens = Dict{UTF8String, Int}()

        for m in 1:n
            for index in 1:(n_words - m + 1)
                token = join(words[index:(index + m - 1)], " ")
                tokens[token] = get(tokens, token, 0) + 1
            end
        end

        tokens
    end

    # Create a NGramDocument from a gram dict
    document(gram) = NGramDocument(gram, n)
    togeneric(docs) = convert(Array{GenericDocument, 1}, docs)

    # Create corpus
    corpus= Corpus(map(x -> x |> tokenize |> ngramize |> document, sentences) |> togeneric)

    # Create lexicon
    update_lexicon!(corpus)

    # Create model with maximum likelihood estimation
    # => Linear approximation
    ml = Dict{UTF8String, Float64}()
    words = collect(UTF8String, keys(lexicon(corpus)))
    n_words = length(words)
    gramcount = lexicon(corpus)


    function likelihood(gram)
        println(join(gram, " "))
        res = 0

        for i = 1:(n-1)
            println("$(i) => $(join(gram[i:end], " ")) / $(join(gram[i:(end - 1)], " "))")
            res += (1 / n) * gramcount[join(gram[i:end], " ")] / gramcount[join(gram[i:(end - 1)], " ")]
        end
        println("$(n) => $(gram[end]) / $(n_words)")
        res += (1 / n) * gramcount[gram[end]] / n_words

        res
    end

    for w in words
        trigram = tokenize(w)

        if length(trigram) == n
            ml[w] = likelihood(trigram)
        end
    end

    NGramModel(ml, n)
end
