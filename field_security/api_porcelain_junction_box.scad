// ==============================================================================
// AGRICULTURE PATHOLOGY INSTITUTE - INFRASTRUCTURE AUTOMATION MODULE
// COMPONENT: PORCELAIN CERAMIC ISOLATION JUNCTION ENCLOSURE (74HC74 ARRAY SPEC)
// FILE: api_porcelain_junction_box.scad
// LICENSING: Boost Software License 1.0 (API Organization Standard)
// COMPLIANCE: AI_TAG_HERO_STYLE_TRUE / HEROIC DETERMINISTIC AUTOMATION
// ==============================================================================

/* [ Global Parameters ] */
// Render resolution quality (higher values yield smoother cuts)
$fn = 120; 

// Micro-adjust clearance parameter to prevent mesh merging glitches
epsilon = 0.05; 

/* [ Enclosure Structural Dimensions ] */
// Enclosure interior length to house 4x 74HC74 DIP-14 IC packages side-by-side
interior_length = 110.0; 
// Enclosure interior width accounting for 3oz copper trace guard rings
interior_width  = 65.0;  
// Enclosure interior height providing clearance for components and wire leads
interior_height = 35.0;  
// Porcelain ceramic wall thickness calculated for industrial dielectric breakdown strength
wall_thickness  = 6.5;   

/* [ Interface Ports & Mounts ] */
// Entrance slot width for the Wrought-Metal Ankh Switch Probe Key
ankh_slot_width   = 32.0; 
// Entrance slot thickness to support Ankh Key leaf spring compression guides
ankh_slot_thick   = 6.0;  
// Conduit aperture diameter for outgoing GE Weatherproof Signal lines
conduit_diameter  = 18.0; 
// Interior mounting standoff pin height for PCB stabilization
standoff_height   = 5.0;  
// Mounting standoff screw diameter (M3 Hardware Spec)
standoff_diameter = 3.2;  

// Derived Exterior Structural Parameters
exterior_length = interior_length + (2 * wall_thickness);
exterior_width  = interior_width  + (2 * wall_thickness);
exterior_height = interior_height + wall_thickness; // Open top for matching lid configuration

// ==============================================================================
// MAIN GEOMETRY CONSTRUCTS
// ==============================================================================

// Render the primary isolated enclosure module
porcelain_junction_base();

// Render the protective tracking lid module offset for geometric visibility
translate([0, exterior_width + 20, exterior_height + wall_thickness]) {
    porcelain_junction_lid();
}

// ==============================================================================
// MODULE IMPLEMENTATIONS
// ==============================================================================

module porcelain_junction_base() {
    difference() {
        // 1. Monolithic Porcelain Outer Block
        cube([exterior_length, exterior_width, exterior_height]);
        
        // 2. Interior Component Cavity Excavation
        translate([wall_thickness, wall_thickness, wall_thickness]) {
            cube([interior_length, interior_width, interior_height + epsilon]);
        }
        
        // 3. Outgoing Conduit Port Aperture (Left Side Wall Entry)
        translate([-epsilon, exterior_width / 2, interior_height / 2 + wall_thickness]) {
            rotate([0, 90, 0]) {
                cylinder(d = conduit_diameter, h = wall_thickness + (2 * epsilon));
            }
        }
    }
    
    // 4. Add Internal PCB Mounting Standoff Rails
    translate([wall_thickness, wall_thickness, wall_thickness]) {
        pcb_standoffs();
    }
}

module porcelain_junction_lid() {
    difference() {
        union() {
            // 1. Primary Lid Top Slab
            cube([exterior_length, exterior_width, wall_thickness]);
            
            // 2. Interlocking Lip to Seat Lid Firmly inside Base Cavity
            translate([wall_thickness + 0.5, wall_thickness + 0.5, -wall_thickness]) {
                cube([interior_length - 1.0, interior_width - 1.0, wall_thickness]);
            }
        }
        
        // 3. Precision Milled Ankh Probe Entry Slot (Centered on the Lid)
        translate([exterior_length / 2 - ankh_slot_width / 2, exterior_width / 2 - ankh_slot_thick / 2, -wall_thickness - epsilon]) {
            cube([ankh_slot_width, ankh_slot_thick, (2 * wall_thickness) + (2 * epsilon)]);
        }
        
        // 4. Parametric Bevel / Chamfer along the Ankh Insertion Guideway Edge
        translate([exterior_length / 2 - ankh_slot_width / 2 - 2.0, exterior_width / 2 - ankh_slot_thick / 2 - 2.0, wall_thickness - 2.0]) {
            cube([ankh_slot_width + 4.0, ankh_slot_thick + 4.0, 2.0 + epsilon]);
        }
    }
}

module pcb_standoffs() {
    // Four corner mounting standoff locations mapped to standard eurocard parameters
    standoff_offsets_x = [10.0, interior_length - 10.0];
    standoff_offsets_y = [10.0, interior_width - 10.0];
    
    for (x = standoff_offsets_x) {
        for (y = standoff_offsets_y) {
            translate([x, y, 0]) {
                difference() {
                    // Standoff Outer Support Cylinder
                    cylinder(d = standoff_diameter + 4.0, h = standoff_height);
                    // Internal Thread Channel for Secure Fastening
                    translate([0, 0, -epsilon]) {
                        cylinder(d = standoff_diameter, h = standoff_height + (2 * epsilon));
                    }
                }
            }
        }
    }
}
