# frozen_string_literal: true

module PoetryHelper
  def il_campo_moretti
    <<~VERSE
      Il Campo Moretti - - Art Shane, April 1997

      Strange things are seen by the River Green
      Just below the Vermont line.
      Hear the frogs the wailing dogs
      The McCullough chainsaw whine.
      In pines so tall whose needles fall
      On a shelter cool and damp.
      With hearthstone lain by Donald Swain,
      Known to kin as Camp.

      The sun's past noon, we're eating soon,
      P. and L. may be coming late.
      As Peter plucks those burger pucks
      From the ancient charcoal grate.
      That slaw looks nice with green pepper slice
      There's a loaf of high tech bake.
      Then the fun seeing ice cream run
      Off just-iced birthday cake.

      Let's make the day, give John his say
      On any given topic.
      A point of view that's park askew,
      The other part myopic.
      A lesson on loam, the Pope in Rome
      Whether Henry's acting girly.
      Remind us then, the last wise men
      Were Larry, Moe and Curly.

      I must remind that beds you'll find
      Were made in yesteryear.
      Their names announce like rodeo mounts
      And should inspire fear.
      There's "Rattler" rack, "Sidewinder" sack
      "The Montague Backbreaker".
      Come try a night on "Dynamite"
      Or the dreaded "Widowmaker".

      There'll be no moving or much improving
      To Michael that's distractin'.
      Would cause a fit to Fran and Whit
      Those cornerstones of Acton.
      Just never let your heart forget,
      Amid the champagne and confetti,
      That homestead hidin' on the edge of Leyden
      The soul of the Moretti.
    VERSE
  end

  def mia_francesca
    <<~VERSE
      Mia Francesca - - Art Shane, July 2005

      For Fran, no never old
      Now let me tell of it
      Our Mon, whose love we hold
      As unchangeable as Whit

      She prepares too much to eat
      Sides and veggies yet abound
      And then complains oh not too sweet
      At how much is left around

      A dying plant she'll never dump
      Wasting wrapping is a sin
      Hating Red Sox in a slump
      And games she doesn't win

      No birthday is ere forgot
      Nor Johnny's wicked deeds
      She loves each babe and tot
      And all the books she reads

      Fran's offsping's found where ere you go
      In Montague and Hubbardston, in Acton and in Stow
      In New Hampshire with Clarks, and Farrars' with homes of logs
      Sure Janet has more grandkids, so what - we've got more dogs

      And I hear Keith just like a pirate say
      "Arrgh listend to me. Matey
      Shiver me timbers on this day
      Lady Fran is turning eighty"

      So here's to Fran and all her days
      And I will end this verse
      With that oft-spoke family phrase
      "Oh well, it could be worse"
    VERSE
  end

  def poem
    send(%i[il_campo_moretti mia_francesca].sample)
  end
end
