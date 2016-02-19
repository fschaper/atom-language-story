# User Story snippets and highlighting

A simple package which extends the atom editor with syntax highlighting and snippets for user stories. Pretty much work in progress.

## Highlighting
The format currently supported follows the textbook style format.
```
As a <ROLE> I want <GOAL> so that <REASON>.
```

You can deviate a bit from the version above. All examples below would be recognized by the parser:

```
# Some feature
As a USER I would like to have syntax highlighting for user stories so that I can better visually parse them.
The user would like to have syntax highlighting for user stories so that he can visually parse them.
a user would like to have syntax highlighting
```

The representation in atom using the solarized-dark syntax theme:
![sample image](support/sample.jpg?raw=true)

## Snippets

Currently two expansions are offered:
- `asn` will expand to `As an {USER} I want {GOAL} so that {REASON}.`
- `asa` in turn will expand to `As a {ROLE} I want {GOAL} so that {REASON}.`

## Reference Material

- [Martin Fowler on User Stories](http://martinfowler.com/bliki/UserStory.html)
