// The project function defines how your document looks.
// It takes your content and some metadata and formats it.
// Go ahead and customize it to your liking!
#let project(
  title: "",
  abstract: [],
  author: "",
  bib: "",
  speakers: (),
  logo: none,
  body,
) = {
  // Set the document's basic properties.
  set document(author: author, title: title)
  set text(font: "New Computer Modern", lang: "it")
  show math.equation: set text(weight: 400)
  set heading(numbering: "1.1", supplement: [Capitolo])

  // Title page.
  // The page can contain a logo if you pass one with `logo: "logo.png"`.
  if logo != none {
    align(center, image(logo, height: 6cm, alt: "logo"))
    v(5mm)
  }
  
  align(center)[
    #text(2em, weight: 500, upper("Università di Pisa"))
    #v(5mm)
    #text(1.4em, weight: 500, upper("Dipartimento di Ingegneria dell'informazione"))
    #v(5mm)
    #text(1.7em, weight: 500, "Laurea Triennale in Ingegneria Informatica")
    #v(15mm)
    #text(1.5em, weight: 500, title)
  ]

  v(27mm)
  
  // Author information.
  grid(
      columns: (1fr, 1fr),
      gutter: 1em,
        align(left)[
          #text(1.5em, weight: 500, "Relatori:")\
          #speakers.map(s => text(1.3em, weight: 400, s)).join("\n")
          
        ],
        align(right)[
          #text(1.5em, weight: 500, "Candidato:")\
          #text(1.3em, weight: 500, author)
        ]
  )

  v(27mm)
  line(length: 100%)
  align(center, [#text(upper("Anno accademico 202X/202Y"))])

  pagebreak()

  // Abstract page.
  v(1fr)
  align(center)[
    #heading(
      outlined: false,
      numbering: none,
      text(0.85em, smallcaps[Abstract]),
    )
    #abstract
  ]
  v(1.618fr)
  pagebreak()

  // Table of contents.
  outline(depth: 3, indent: true)
  pagebreak()
  
  set page(number-align: center, numbering: "1")

  show heading: it =>{
    if(it.level == 1){
      pagebreak(weak: true)
    }else{
      v(2.5em, weak: true)
    }
    it
    v(1em, weak: true)
  }

  // show raw: it => text(font: "Fira Code",it);
  show raw: it => {
    if(it.block){
       block(
        fill: luma(246),
        width: 100%,
        inset: 1em,
        radius: 5pt,
        text(font: "Fira Code",it)
      )
    }else{
      text(font: "Fira Code",it)
    }
  }
    
  
  // Main body.
  set par(justify: true)
  

  body

  
  if(bib.len() > 0){
    bibliography(bib, style: "ieee")
  }
}