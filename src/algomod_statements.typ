#import "algomod.typ": updateIndent, createStatement

#let Function(funcName, args) = {
  let argBody = [$(#args)$]

  return createStatement(
    postIndent: 1,
    [*Function* #funcName#argBody *Do*],
  )
}

#let Return(statement) = {
  return createStatement(
    [*Return* #statement],
  )
}

#let End() = {
  return createStatement(
    preIndent: -1,
    [*End*],
  )
}

#let Let(statement) = {
  return createStatement(
    [*Let* #statement],
  )
}

#let If(condition) = {
  return createStatement(
    postIndent: 1,
    [*If* #condition *Then*],
  )
}

#let ElseIf(condition) = {
  return createStatement(
    preIndent: -1,
    postIndent: 1,
    [*Else If* #condition *Then*],
  )
}

#let Else() = {
  return createStatement(
    preIndent: -1,
    postIndent: 1,
    [*Else*],
  )
}

#let ForAll(var, iterable) = {
  return createStatement(
    postIndent: 1,
    [*For All* #var $<-$ #iterable *Do*],
  )
}

#let While(condition) = {
  return createStatement(
    postIndent: 1,
    [*While* #condition *Do*],
  )
}

#let Repeat() = {
  return createStatement(
    postIndent: 1,
    [*Repeat*],
  )
}

#let Until(condition) = {
  return createStatement(
    preIndent: -1,
    [*Until* #condition],
  )
}