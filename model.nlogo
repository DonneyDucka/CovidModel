extensions [matrix array]
breed [houses house]
breed [workplaces work]
breed [people person]
breed [shops shop]

globals [
 contact-rate
 economy-value
]

people-own [
 infected?     ;; has the person been infected with the disease?
 workp
 p-home
 work-time
 rest-time
 lunch-spot
 symptom-time
 recovered?
 incubation-time
 isolating?
 time-period
 isolation-time
]

patches-own [
 p-infected?
 infect-time
 type-of
]

;;;;;;;;;;;;;;;;;;;;;;;;
;;; Setup Procedures ;;;
;;;;;;;;;;;;;;;;;;;;;;;;

to setup
  clear-all
  set-default-shape people "person"
  set-default-shape houses "house"
  set-default-shape shops "square"
  set-default-shape workplaces "square 2"
  make-map
  draw-places
  place-people
  infect
  recolor
  set economy-value 0
  set contact-rate 0
  reset-ticks
end

to make-map

  let agents-map matrix:from-row-list [
    [0 1 1 1 1 0 1 1 1 1 1 1 1 1 0 1 1 1 1 0 1 0 1 1 1 0 1 1 1 1 0 1 1 1 1 1 1 1 1 0 1 1 1 1 0 1 0 1 1 1]
    [0 0 0 0 0 0 0 0 1 0 0 0 1 1 0 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 1 1 0 1 1 0 0 0 0 0 0 0 0]
    [0 1 1 0 1 1 1 0 0 0 1 0 0 0 0 0 0 0 1 1 1 0 1 1 1 0 1 1 0 1 1 1 0 0 0 1 0 0 0 0 0 0 0 1 1 1 0 1 1 1]
    [0 0 0 0 1 0 0 0 1 0 1 0 1 1 1 0 1 0 1 1 0 0 0 0 1 0 0 0 0 1 0 0 0 1 0 1 0 1 1 1 0 1 0 1 1 0 0 0 0 1]
    [0 1 1 0 0 0 1 0 0 0 1 0 0 0 1 0 0 0 0 0 0 1 1 0 1 0 1 1 0 0 0 1 0 0 0 1 0 0 0 1 0 0 0 0 0 0 1 1 0 1]
    [0 0 0 1 1 0 1 1 1 1 1 1 0 1 1 1 0 1 0 1 0 1 0 0 0 0 0 0 1 1 0 1 1 1 1 1 1 0 1 1 1 0 1 0 1 0 1 0 0 0]
    [1 1 0 0 0 0 0 0 1 0 0 1 0 1 1 0 0 1 0 1 0 0 0 1 1 1 1 0 0 0 0 0 0 1 0 0 1 0 1 1 0 0 1 0 1 0 0 0 1 1]
    [1 1 0 1 1 1 1 0 0 0 1 1 0 1 1 0 1 1 0 1 0 1 0 1 1 1 1 0 1 1 1 1 0 0 0 1 1 0 1 1 0 1 1 0 1 0 1 0 1 1]
    [1 1 0 0 0 0 1 0 1 0 1 1 0 0 0 0 0 1 0 1 0 1 0 0 0 1 1 0 0 0 0 1 0 1 0 1 1 0 0 0 0 0 1 0 1 0 1 0 0 0]
    [1 1 0 1 1 0 0 0 1 0 1 1 0 1 1 1 0 1 0 1 0 0 0 1 1 1 1 0 1 1 0 0 0 1 0 1 1 0 1 1 1 0 1 0 1 0 0 0 1 1]
    [1 1 0 1 1 0 1 0 0 0 1 1 0 1 1 1 0 1 0 0 0 1 0 1 1 1 1 0 1 1 0 1 0 0 0 1 1 0 1 1 1 0 1 0 0 0 1 0 1 1]
    [0 0 0 1 1 0 1 0 1 0 1 1 0 0 0 0 0 1 0 1 0 1 0 1 1 0 0 0 1 1 0 1 0 1 0 1 1 0 0 0 0 0 1 0 1 0 1 0 1 1]
    [1 1 0 1 1 1 1 0 1 1 1 1 0 1 1 1 0 1 0 1 0 1 0 1 1 1 1 0 1 1 1 1 0 1 1 1 1 0 1 1 1 0 1 0 1 0 1 0 1 1]
    [1 1 0 1 0 0 0 0 0 1 0 1 0 1 0 0 0 1 0 0 0 1 0 1 1 1 1 0 1 0 0 0 0 0 1 0 1 0 1 0 0 0 1 0 0 0 1 0 1 1]
    [1 1 0 1 1 0 1 0 1 1 0 1 0 1 1 1 0 1 0 1 0 1 0 1 1 1 1 0 1 1 0 1 0 1 1 0 1 0 1 1 1 0 1 0 1 0 1 0 1 1]
    [1 1 0 0 0 0 1 0 1 0 0 0 0 0 0 0 0 1 0 1 0 0 0 0 1 1 1 0 0 0 0 1 0 1 0 0 0 0 0 0 0 0 1 0 1 0 0 0 0 1]
    [1 1 1 1 1 0 1 0 1 1 0 1 0 1 1 1 0 0 0 0 0 1 1 0 1 1 1 1 1 1 1 1 0 1 1 0 1 0 1 0 1 0 0 0 0 0 1 1 0 1]
    [0 1 1 1 1 0 1 1 1 1 1 1 1 1 0 1 1 1 1 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 1 1 1 0 1 1 1 1 0 1 0 1 1 1]
    [0 0 0 0 0 0 0 0 1 0 0 0 1 1 0 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 1 1 0 1 1 0 0 0 0 0 0 0 0]
    [0 1 1 0 1 1 1 0 0 0 1 0 0 0 0 0 0 0 1 1 1 0 1 1 1 0 1 1 0 1 1 1 0 0 0 1 0 0 0 0 0 0 0 1 1 1 0 1 1 1]
    [0 0 0 0 1 0 0 0 1 0 1 0 1 1 1 0 1 0 1 1 0 0 0 0 1 0 0 0 0 1 0 0 0 1 0 1 0 1 1 1 0 1 0 1 1 0 0 0 0 1]
    [0 1 1 0 0 0 1 0 0 0 1 0 0 0 1 0 0 0 0 0 0 1 1 0 1 0 1 1 0 0 0 1 0 0 0 1 0 0 0 1 0 0 0 0 0 0 1 1 0 1]
    [0 0 0 1 1 0 1 1 1 1 1 1 0 1 1 1 0 1 0 1 0 1 0 0 0 0 0 0 1 1 0 1 1 1 1 1 1 0 1 1 1 0 1 0 1 0 1 0 0 0]
    [1 1 0 0 0 0 0 0 1 0 0 1 0 1 1 0 0 1 0 1 0 0 0 1 1 1 1 0 0 0 0 0 0 1 0 0 1 0 1 1 0 0 1 0 1 0 0 0 1 1]
    [1 1 0 1 1 1 1 0 0 0 1 1 0 1 1 0 1 1 0 1 0 1 0 1 1 1 1 0 1 1 1 1 0 0 0 1 1 0 1 1 0 1 1 0 1 0 1 0 1 1]
    [1 1 0 0 0 0 1 0 1 0 1 1 0 0 0 0 0 1 0 1 0 1 0 0 0 1 1 0 0 0 0 1 0 1 0 1 1 0 0 0 0 0 1 0 1 0 1 0 0 0]
    [1 1 0 1 1 0 0 0 1 0 1 1 0 1 1 1 0 1 0 1 0 0 0 1 1 1 1 0 1 1 0 0 0 1 0 1 1 0 1 1 1 0 1 0 1 0 0 0 1 1]
    [1 1 0 1 1 0 1 0 0 0 1 1 0 1 1 1 0 1 0 0 0 1 0 1 1 1 1 0 1 1 0 1 0 0 0 1 1 0 1 1 1 0 1 0 0 0 1 0 1 1]
    [0 0 0 1 1 0 1 0 1 0 1 1 0 0 0 0 0 1 0 1 0 1 0 1 1 0 0 0 1 1 0 1 0 1 0 1 1 0 0 0 0 0 1 0 1 0 1 0 1 1]
    [1 1 0 1 1 1 1 0 1 1 1 1 0 1 1 1 0 1 0 1 0 1 0 1 1 1 1 0 1 1 1 1 0 1 1 1 1 0 1 1 1 0 1 0 1 0 1 0 1 1]
    [1 1 0 1 0 0 0 0 0 1 0 1 0 1 0 0 0 1 0 0 0 1 0 1 1 1 1 0 1 0 0 0 0 0 1 0 1 0 1 0 0 0 1 0 0 0 1 0 1 1]
    [1 1 0 1 1 0 1 0 1 1 0 1 0 1 1 1 0 1 0 1 0 1 0 1 1 1 1 0 1 1 0 1 0 1 1 0 1 0 1 1 1 0 1 0 1 0 1 0 1 1]
    [1 1 0 0 0 0 1 0 1 0 0 0 0 0 0 0 0 1 0 1 0 0 0 0 1 1 1 0 0 0 0 1 0 1 0 0 0 0 0 0 0 0 1 0 1 0 0 0 0 1]
    [1 1 1 1 1 1 1 0 1 1 0 1 0 1 1 1 0 0 0 0 0 1 1 0 1 1 1 1 1 1 1 1 0 1 1 0 1 0 1 1 1 0 0 0 0 0 1 1 0 1]
  ]
  let i 49
  let j 33
  let counter 0
  let cord matrix:get agents-map j i

  while[i >= 0] [

    while[j >= 0] [
      set cord matrix:get agents-map j i

      if cord = 0 [ask patch i j [set pcolor grey set type-of "road"]]
      if cord = 1 [ask patch i j [set pcolor lime set type-of "commercial"]]

      ;if cord = 3 [ask patch i j [set pcolor lime set type-of "building"]]
      set j j - 1
    ]
    set j 33
    set i i - 1
  ]

end

to place-people

  ask patches with [type-of = "house"] [
    sprout-people per-household [
      set color white
      set size 0.3
      set p-home patch-here
      set workp one-of patches with [type-of = "workplaces" or type-of = "shop"]
      let a array:from-list [6 7 8 9 10]
      set work-time array:item a (random 5)
      set rest-time 0
      set infected? false
      set recovered? false
      set lunch-spot "none"
    ]
  ]

end

to draw-places

  ask n-of num-of-buildings patches with [type-of = "commercial"] [
    set type-of "workplaces"
  ]

  ask n-of num-shops patches with [type-of = "commercial"] [
    set type-of "shop"
  ]

  ask n-of num-of-houses patches with [type-of = "commercial"] [
    set type-of "house"
  ]

   ask patches with [type-of = "workplaces"] [
    sprout-workplaces 1 [
    set color blue
    ]
  ]
   ask patches with [type-of = "house"] [
     sprout-houses 1 [
    set color brown
    ]
  ]
   ask patches with [type-of = "shop"] [
     sprout-shops 1 [
    set color violet
    ]
  ]



end


to infect
  ask n-of num-infected people [
    set symptom-time 0
    set infected? true
    let distribution floor random-normal 7 2
    set incubation-time (distribution) ;using the sample of 1,5,7,14 where the mean is 4.9 - 7 with a range of 1 - 14
    set time-period incubation-time * 24
  ]
end

to recolor
  ask people [
    ;; infected turtles are red, others are gray
    if incubation-time > 0 [set color pink]
    if symptom-time > 0 [set color yellow]
    if recovered? = true [set color green]
  ]
end

to move-randomly

end

;;;;;;;;;;;;;;;;;;;;;;;
;;; Main Procedures ;;;
;;;;;;;;;;;;;;;;;;;;;;;

to go
  ;if all? people [ infected? ] [ stop ]
  spread-infection
  recolor
  (ifelse variation = "scheduled"
    [move-with-schedule]
  variation = "restricted-movement-policy"
  [move-with-policy]
  )
  if( remainder ticks 24 = 0) [
    calc-contact-rate
  ]
  tick
end


to calc-contact-rate
 let contact-number 0
 ask people with [infected? = false ]
  [
    set contact-number contact-number + count people in-radius 0.5 with [infected? = true]
  ]
  set contact-rate contact-number / count people with [infected? = false]
end


to spread-infection
   ask patches with [ p-infected? = true] [
    ;; count down to the end of the patch infection

    set infect-time infect-time - 1
  ]

  ask people-on patches with [p-infected? = true] [
    let chance random infect-prob
    if chance = 0 and recovered? = false and infected? = false [
      let distribution ceiling random-normal 7 2
      set incubation-time (distribution) * 24
      set time-period incubation-time
      set infected? true
      ask patch-here [
      set p-infected? true
      set infect-time surface-duration
      ]
    ]
  ]

  ask people [

    (ifelse
    incubation-time > 0 [
    let chance random ( infect-prob * 10)
    set incubation-time incubation-time - 1
    if chance = 0 [
        ask patch-here [
          set p-infected? true
          set infect-time surface-duration
        ]
    ]
    if incubation-time = 0 [
      set symptom-time (14 * 24 ) - time-period
      ]
    ] ; 14 days is the maximum value
    symptom-time > 0  [
    let chance random infect-prob / 2
    set symptom-time symptom-time - 1
    if chance = 0 [
        ask patch-here [
          set p-infected? true
          set infect-time surface-duration
        ]
    ]
    if symptom-time = 0 [
      set recovered? true
      set infected? false
      ]

    ])
  ]

end

;;;;;;;;;;;;;;
;;; Layout ;;;
;;;;;;;;;;;;;;
to move-around
      (ifelse distance workp = 0 and work-time > 0
      [ set work-time work-time - 1
        set economy-value economy-value + 1
        face p-home
      ]

      distance workp = 0 and work-time = 4
       [ let store one-of patches in-radius 8 with [type-of = "shop"]
        face store
        ifelse distance store < 4
        [ move-to store ] [fd 4]

      ]

        distance workp = 0 and work-time = 4
       [ let store one-of patches in-radius 20 with [type-of = "shop"]
        face store
        ifelse distance store < 10
        [ move-to store  set work-time "lunch"] [fd 10 set lunch-spot store set work-time "going2lunch"]
       ]

      work-time = "going2lunch"
      [ move-to lunch-spot]

        work-time = "lunch"
      [ set work-time "back2work" ]

      work-time = "back2work"
      [  ifelse distance workp < 10 [ move-to workp set work-time 3]
         [ face workp fd 10]
      ]

    distance p-home > 8 and work-time = 0
      [
        face p-home
        fd 8
      ]
   distance p-home <= 8 and work-time = 0
      [
        move-to p-home
        set rest-time 16
        set work-time 8
      ]
    distance p-home = 0  and rest-time > 0
    [ set rest-time rest-time - 1
    ]
     distance p-home = 0  and rest-time > 0
    [ set rest-time rest-time - 1
    ]

    distance workp <= 8
      [ move-to workp

      ]
    distance workp > 8
      [ face workp
        fd 8
      ]
      )
end

to move-with-schedule

  ask people with [symptom-time > 0 and rest-time > 0]
  [
    let likelihood random 3

    if likelihood = 0 [
     set rest-time rest-time + 1
    ]

  ]
  ask people
  [move-around
  ]

end

to move-with-policy

  ask people with [symptom-time > 0 or  isolation-time > 0]
  [
    set work-time 0
    set rest-time 7 * 24
    set infected? false

    (ifelse
        distance p-home > 8
      [ face p-home
        fd 8
      ]
      distance p-home <= 8 and isolation-time = 0
      [
        move-to p-home
        set isolation-time 7 * 24
        ask patch-here [
        set p-infected? false
        set infect-time 0
        ]
      ]
     isolation-time > 0
      [
        set isolation-time isolation-time - 1
         ask patch-here [
        set p-infected? false
        set infect-time 0
        ]
        if isolation-time = 0
        [set recovered? true
        ]

      ]

    )
  ]

  ask people with [symptom-time = 0]
  [move-around
  ]

end

to do-layout
  layout-spring turtles with [ any? link-neighbors ] links 0.4 6 1
  display  ;; so we get smooth animation
end

;; This procedure allows you to run the model multiple times
;; and measure how long it takes for the disease to spread to
;; all people in each run. For more complex experiments, you
;; would use the BehaviorSpace tool instead.
to my-experiment
  repeat 10 [

    setup
    while [ not all? turtles [ infected? ] ] [ go ]
    print ticks
  ]
end
@#$#@#$#@
GRAPHICS-WINDOW
720
13
1681
670
-1
-1
19.08
1
10
1
1
1
0
1
1
1
0
49
0
33
1
1
1
ticks
30.0

CHOOSER
22
35
222
80
variation
variation
"scheduled" "restricted-movement-policy"
0

SLIDER
200
90
372
123
per-household
per-household
1
4
1.0
1
1
NIL
HORIZONTAL

SLIDER
23
89
195
122
num-infected
num-infected
1
200
10.0
1
1
NIL
HORIZONTAL

MONITOR
22
165
82
210
Infected
count people with [symptom-time > 0 or incubation-time > 0]
3
1
11

SLIDER
199
127
371
160
infect-prob
infect-prob
1
10
5.0
1
1
NIL
HORIZONTAL

BUTTON
453
89
516
122
setup
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
376
90
451
123
go once
go
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
376
126
439
159
go
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

PLOT
24
237
339
486
Infection vs. Time
Time (hrs)
NIL
0.0
10.0
0.0
1.0
true
true
"" ""
PENS
"people" 1.0 0 -16777216 true "" "plot per-household * num-of-houses "
"symptomatic people " 1.0 0 -1184463 true "" "plot count people with [symptom-time > 0 ] "
"incubation people" 1.0 0 -3508570 true "" "plot count people with [incubation-time > 0]"
"recovered people" 1.0 0 -13840069 true "" "plot count people with [recovered? = true]"

MONITOR
91
165
148
210
Days
ticks / 24
2
1
11

PLOT
352
234
690
484
R0
Time
NIL
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"R0" 1.0 0 -16777216 true "" "let transmissibility 1 / infect-prob\nif remainder ticks 24 = 0 [\nplot transmissibility * contact-rate * 14]\n\n\n"

MONITOR
158
166
215
211
R0
(1 / infect-prob) * contact-rate * surface-duration
2
1
11

SLIDER
270
176
442
209
num-of-houses
num-of-houses
3
500
500.0
1
1
NIL
HORIZONTAL

SLIDER
454
176
626
209
num-of-buildings
num-of-buildings
3
170
170.0
1
1
NIL
HORIZONTAL

MONITOR
645
10
705
55
buildings
count patches with [type-of = \"shop\" or type-of = \"building\"]
3
1
11

MONITOR
611
68
703
113
patches
count patches with [pcolor = lime]
2
1
11

SLIDER
454
136
626
169
num-shops
num-shops
2
170
170.0
1
1
NIL
HORIZONTAL

MONITOR
579
10
636
55
houses
count patches with [type-of = \"house\"]
1
1
11

MONITOR
507
10
564
55
people
per-household * num-of-houses
2
1
11

INPUTBOX
390
12
484
72
surface-duration
24.0
1
0
Number

MONITOR
38
524
101
569
Economy
economy-value
17
1
11

PLOT
139
499
339
649
Rate of economic growth 
Time
Increase
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "if remainder ticks 24 = 0 [\nplot economy-value / ticks\n]"

@#$#@#$#@
## WHAT IS IT?

(a general understanding of what the model is trying to show or explain)

## HOW IT WORKS

(what rules the agents use to create the overall behavior of the model)

## HOW TO USE IT

(how to use the model, including a description of each of the items in the Interface tab)

## THINGS TO NOTICE

(suggested things for the user to notice while running the model)

## THINGS TO TRY

(suggested things for the user to try to do (move sliders, switches, etc.) with the model)

## EXTENDING THE MODEL

(suggested things to add or change in the Code tab to make the model more complicated, detailed, accurate, etc.)

## NETLOGO FEATURES

(interesting or unusual features of NetLogo that the model uses, particularly in the Code tab; or where workarounds were needed for missing features)

## RELATED MODELS

(models in the NetLogo Models Library and elsewhere which are of related interest)

## CREDITS AND REFERENCES

(a reference to the model's URL on the web if it has one, as well as any other necessary credits, citations, and links)
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.1.1
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
