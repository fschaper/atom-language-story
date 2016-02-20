module.exports =
  # This will work on User Story files.
  selector: '.source.story'

  # This will take priority over the default provider, which has a priority of 0.
  # `excludeLowerPriority` will suppress any providers with a lower priority
  # i.e. The default provider will be suppressed
  inclusionPriority: 1
  excludeLowerPriority: false

  isRolePosition: (editor, bufferPosition) ->
    rolePosition = ///^                 # beginning of the line
                    \s*                 # skip 0 to n whitespaces at the beginning
                   (?:as\s)?            # the sentence may optionally start with "as" followed by an whitespace
                    (?:(?:a|an|the)\s)? # and continue or start with a/an/the followed by an whitespace
                    $                   # end of line
                  ///i
    currentLine = editor.getTextInRange([[bufferPosition.row, 0], bufferPosition])
    return currentLine.match rolePosition

  # Required: Return a promise, an array of suggestions, or null.
  getSuggestions: ({editor, bufferPosition, scopeDescriptor, prefix, activatedManually}) ->
    if not @isRolePosition(editor, bufferPosition)
      return null

    new Promise (resolve) ->
      roleExpression = ///^                 # beginning of the line
                        \s*                 # skip 0 to n whitespaces at the beginning
                        (?:as\s)?           # the sentence may optionally start with "as" followed by an whitespace
                        (?:(?:a|an|the)\s)? # and continue or start with a/an/the followed by an whitespace
                        (\w+)               # followed by the role
                      ///i
      roles = []
      # scan for ROLE definitions from the beginning of the
      # document up to the current line
      for currentLine in [0..bufferPosition.row-1]
        line = editor.lineTextForBufferRow(currentLine)
        role = (roleExpression.exec line)?[1] or ''
        roles.push( text: role )
      resolve( roles )
