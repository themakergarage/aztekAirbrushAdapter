/*  aztekAirBrushAdapter v1
    Copyright (C) 2017 The Maker Garage

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
  
    About this file:
    Some (all?) Testor Aztek Airbrushes are designed to work with the compressed cans of air.  As far as I can tell the connector is non-standard.
    
    This file creates an adapter that allows a Testor Aztek Airbrush to be connected directly to a 1/4" NTP fitting so it can be used with a compressor.
*/

use <tmg_scad_lib/threadedRod.scad>
use <tmg_scad_lib/hex.scad>

// Increase default precision
$fn = 36;



// Combine the 3 parts of the adapter
union(){
    makeQuarterNPT();
    translate([0, 0, 9]) makeNutFlange ();
    translate([0, 0, 14]) makeAztec();
}



// This is the flange that connects the fittings
module makeNutFlange (){
    difference(){
        linear_extrude(height=5)
        roundedHex(16);
        // Create a tapered port that should allow for better air 
        // flow than a strait port.  More importantly, this results 
        // in a cleaner print.
        cylinder(h=5, d1=12.5, d2= 5.7);
        // Add a crude fillet to the top
        translate([0, 0, -9])difference(){
            sphere(17);
            sphere(16);
        }
        // Add a crude fillet to the bottom
        translate([0, 0, 14])difference(){
            sphere(17);
            sphere(16);
        }
    
    }
}


// This is the female 1/4 NPT fitting
module makeQuarterNPT () {
    // These are the measurments used to make the fitting
    innerDiameter = 12.5;
    outerDiameter = 13.5;
    height = 9;
    pitch = 1.45;

    difference () {
        // Create the shell of the fitting
        cylinder(h=height, d=outerDiameter+2.5);
        // Tap the threads
        threadedRod(innerDiameter, outerDiameter, height, pitch);
        // Add a crude inner fillet
        // This enables easier connecting
        cylinder(h=1, d1=outerDiameter, d2=innerDiameter);
    }
}


// This is the male Aztek fitting
module makeAztec() {
    // These are the measurments used to make the fitting
    innerDiameter = 10;
    outerDiameter = 10.8;
    height = 10;
    pitch = 1;

    difference () {
        // Create the threads on a a solid cylinder
        threadedRod(innerDiameter, outerDiameter, height, pitch);
        // Create the inner hollow
        cylinder(h=height, d=5.7);
        // Create a crude inner fillet
        // This also creates a nice seat for the o-ring
        // of the Aztek connector
        translate([0, 0, 9]) 
        cylinder(h=1, d1=5.7, d2=7.3);
        // Create a crude outer fillet
        // This enables easier connecting
        translate([0, 0, -6])difference(){
            sphere(18);
            sphere(16);
        }
    }

}
