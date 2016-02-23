module.exports =
  # This will work on User Story files.
  selector: '.source.story'

  # This will take priority over the default provider, which has a priority of 0.
  # `excludeLowerPriority` will suppress any providers with a lower priority
  # i.e. The default provider will be suppressed
  inclusionPriority: 1
  excludeLowerPriority: false

  # Tell autocomplete to fuzzy filter the results of getSuggestions()
  filterSuggestions: true

  isRolePosition: (editor, bufferPosition) ->
    rolePosition = ///^                         # beginning of the line
                    \s*                         # skip 0 to n whitespaces at the beginning
                    (?:
                      as|                       # the sentence may optionally start with "as"
                      (?:a|an|the)|             # or start with a/an/the
                      as\s+(?:a|an|the)         # or a combination of the two
                    )
                    \s+\w*                      # followed by a whitespace and optionaly the role
                    $                           # end of line
                  ///i
    currentLine = editor.getTextInRange([[bufferPosition.row, 0], bufferPosition])
    return currentLine.match rolePosition

  # Required: Return a promise, an array of suggestions, or null.
  getSuggestions: ({editor, bufferPosition, scopeDescriptor, prefix, activatedManually}) ->

    # only perform the lookup in case the input is in the "ROLE" position of a story.
    if not @isRolePosition(editor, bufferPosition)
      return null

    # the expression used, to find role identifiers in the current document
    roleExpression = ///^                 # beginning of the line
                      \s*                 # skip 0 to n whitespaces at the beginning
                      (?:as\s)?           # the sentence may optionally start with "as" followed by an whitespace
                      (?:(?:a|an|the)\s)? # and continue or start with a/an/the followed by an whitespace
                      (\w+)               # followed by the role
                    ///i

    # remove any whitespace at the beginning or end of the prefix
    # so that it is easier to use as a lookup.
    prefix = prefix.trim()
    # regexp used for incremental search - used to filter the result.
    prefixExpression = new RegExp(prefix,'i')

    # the row range that we are scanning for role identifiers.
    # we are skipping the current line, so we are not adding an partial match.
    linesToSearch = [0..editor.getLineCount()-1]
    linesToSearch.splice(bufferPosition.row, 1)

    roles = []
    for currentLine in linesToSearch
      line = editor.lineTextForBufferRow(currentLine)
      role = (roleExpression.exec line)?[1] or ''
      roles.push( text: role ) if not prefix or role.match(prefixExpression)
      
    return roles
