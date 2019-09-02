# Project Parts Selection

Guide to choosing parts for electrical projects.

---
When selecting parts to be used in projects, only use parts not in the "standard list" \(below\) if absolutely necessary. Most of the time it's not. For example, pull-up resistors, 2:1 resistor dividers, LED current limiters, etc.

In other cases, the value you want can be formed by having standard-valued resistors/capacitors in series or parallel. If you need many many resistors of a non-standard value, it may make sense to just use that value - in that case, use your best judgment. In the case of decoupling, it is USUALLY okay to substitute bigger capacitors with smaller ones in parallel \(eg, 2x100nF instead of 220nF\), but NOT the other way.

Here are some of the parts we standardized on \(please add parts here if you use a part in a project that you think has a high chance of being reusable in another project\):

## Standard Parts List

**Surface mount resistors \(\*1\)**

* Values - 10n \(for integer n\). 100, 1k, 10k, 100k are the most common ones
* 0805 size \(that's 0.008" by 0.005"\)
* 1% tolerance
* 1/8 W
* Voltage rating 150V

**Surface mount capacitors \(\*2\)**

* Values - 10n \(for integer n\). 10nF, 100nF, 1uF, 10uF are the most common ones. +22pF for crystals
* 0805 size, except for 10uF which is 1206
* X5R/X7R dielectric \(they are interchangeable for our purposes\), with the exception of 22pF which is NP0.
* Voltage rating &gt;= 25V

**Diodes**

NSR0240HT1GOSCT-ND

* 250mA continuous, Schottky
* Reverse voltage rating 40V

**MOSFETs**

* 497-12940-1-ND \(big N-MOS\)
* 568-5818-1-ND \(small N-MOS\)
* IRF9310TRPBFCT-ND \(small P-MOS\)

**LEDs \(don't use through-hole\)**

Red and green

* 1206 size
* Use 100 ohms for series resistance for 3.3V/5V, 1K ohms for 5V-30V

## Picking New Components

If you need a component, and you think we may already be using it on another board, check other boards first \(or ask one of the senior members since we usually know what components are on all the boards\). If you have to choose a new component, choose one that will likely be useful for other projects as well \(eg. you may not care if a diode is rated for 10V or 50V, but choose the 50V one anyways because that's more likely to be useful to other people\).

## DigiBom

DigiBom is the tool we use to automatically generate Digikey orders from our schematics. It generates components based on the rules listed above for resistors and capacitors. Which means, if you have a 10uF on your PCB with a 0805 footprint, it won't work, because Digibom will automatically order a 1206 one for you unless you override it.

## Why?

We are trying to reduce the total number of different components we have in our stock, so that our current stock of 7 electrical component boxes will not keep on growing. We will hopefully shrink the stock once we decide to stop supporting older robots and dongles, etc., and throw away their spare parts.

This means it will also be easier to assemble \(solder\) boards since there would be less components to go through.

## Two Most Important Rules

1. Do not use through-hole resistors on PCBs unless you have a good reason to. Surface mount is better in almost every single way if you know how to solder them. And we do.
2. Always use surface mount ceramic capacitors.

## Libraries

We have a bunch of parts in our library already. Further, KiCAD and Altium come with a bunch of parts as well. If you don’t find what you need, either draw the part yourself or download it. If you download, don’t add the whole library, rather just open the library, extract the part you need, and add it to our own local library. Some places to look for parts are:

* [SnapEDA](https://www.snapeda.com/)
* [KiCAD part libraries](http://smisioto.no-ip.org/elettronica/kicad/kicad-en.htm)
* [SamacSys](http://www.samacsys.com/pcb-part-libraries/)

## Final Step - Purchase

Now that you have selected parts, see the [Purchasing Protocol](../general-resources/purchasing-parts.md) for how to buy the components.
