#let algomodState = state("algomod_state", (
  number: 0,
  indent: 0,
))

#let updateIndent(lambda) = {
  assert(type(lambda) == "function")

  algomodState.update(dict => {
    let indent = lambda(dict.indent)

    dict.indent = calc.max(indent, 0)

    return dict
  })
}

#let createStatement(
  preIndent: 0,
  postIndent: 0,
  body,
) = {
  let newBody = body

  if body != none {
    newBody = (body, )
  }

  return (
    preIndent: preIndent,
    postIndent: postIndent,
    body: newBody,
  )
}

//
// environment
//
#let algomod = (
  indentSize: 1em,
  format: none,
) => {
  assert(
    type(indentSize) == "length", 
    message: "expected relative length, got " + type(indentSize) + ".")
  assert(
    format == none or type(format) == "function",
    message: "expected none or function, got " + type(format) + ".")

  let template = (
    title: "",
    label: none,
    lines: ()
  ) => {
    assert(
      type(title) == "content" or type(title) == "string",
      message: "expected content or string, got " + type(title))
    assert(
      type(label) == "none" or type(label) == "label",
      message: "expected content or string, got " + type(title))
    assert(
      type(lines) == "array",
      message: "expected array, got " + type(lines))
    assert(
      lines.all(v => type(v) == "dictionary" or type(v) == "content"),
      message: "unexpected line type.")

    // convert raw content to statement object
    lines = lines.map(line => {
      if type(line) == "content" {
        return createStatement(line)
      }
      return line
    })

    let reservedIndent = 0
    for (i, line) in lines.enumerate() {
      if line.body == none {
        reservedIndent += line.preIndent + line.postIndent
      } else {
        lines.at(i).preIndent += reservedIndent
        reservedIndent = 0
      }
    }

    // delete empty body
    lines = lines.filter(v => v.body != none)

    // update algorithm number
    algomodState.update(dict => {
      dict.number = dict.number + 1
      return dict
    })

    let algorithmNumber = algomodState.display(v => [#v.number])

    let formattedLines = ()
    for line in lines {
      formattedLines.push(
        algomodState.display(v => {
          let indentAmount = v.indent + line.preIndent
          for body in line.at("body") {
            [#h(indentSize * indentAmount) #body]
          }
          updateIndent(w => w + line.preIndent + line.postIndent)
        })
      )
    }

    let displayFormat = format
    let displayTitle = [*Algorithm #algorithmNumber* #title]

    if displayFormat == none {
      displayFormat = (title, body) => [
        #pad(bottom: -.8em, align(center, line(length: 100%))) 
        #pad(left: 1em, [#title#label])
        #pad(top: -.8em, bottom: -.6em, align(center, line(length: 100%)))

        #enum(..formattedLines)

        #pad(top: -.6em, align(center, line(length: 100%)))
      ]
    }

    return displayFormat(displayTitle, formattedLines)
  }

  return template
}


//
// reference
//
#let algomodLink(label) = {
  locate(loc => {    
    let labelLocation = query(label, loc)
      .first()
      .location()
    let number = algomodState
      .at(labelLocation)
      .at("number")

    return link(labelLocation, [Algorithm #number])
  })
}
