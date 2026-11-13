// =============================================================================
// MeshCore Solar Node Enclosure
// Parametric OpenSCAD — PETG / ASA, 0.2 mm layers, no supports
// Units: millimeters
//
// Layout: one 240 mAh pouch in a side slot on EACH side (cells on edge),
//         Seeed XIAO nRF52840 + Wio-SX1262 stack and INA3221 / CN3791 in
//         the center. Flat back bonds to the solar-panel back with VHB.
//         Lid is on the accessible face (away from the panel).
//         45° foot is a separate part, bolts to the PG7 / low end.
//
// Seal:   tongue-and-groove labyrinth + 2.0 mm silicone cord groove
//         (22% compression), M3 screws OUTSIDE the seal line into
//         blind heat-set inserts. No USB-C opening.
//         PG7 gland, SMA bulkhead with flat O-ring seat.
// =============================================================================

/* [Export] */
part     = "assembly"; // [box, lid, foot, assembly, preview, sitting, cutaway, dims]
explode  = 18;         // mm, assembly / preview only

/* [Batteries — 502030-class 240 mAh 1S pouch; edit to match your cells] */
// Assumed cell WITH PCM: 32.5 x 20.2 x 5.5 mm
// (Fly-Power FLP-502030 240 mAh is 32.5 x 20.2 x 5.1; 5.5 covers typical 502030.)
bat_l        = 32.5;   // length including PCM tab, mm
bat_w        = 20.5;   // width, mm (becomes pocket HEIGHT — cells stand on edge)
bat_t        =  5.5;   // thickness, mm
bat_clear_l  =  0.9;   // end clearance, each end
bat_clear_w  =  0.8;   // width clearance (toward lid)
bat_clear_t  =  1.2;   // thickness clearance, includes pouch swell

/* [Seeed stack — XIAO nRF52840 on Wio-SX1262] */
seeed_l = 21.0;        // official planform 21 x 17.8 mm
seeed_w = 17.8;
seeed_h = 24.0;        // official stacked height 21 mm; 24 allows header / U.FL variation

/* [INA3221 — MCU-3221 / MusRock B0FTF9LC1T] */
ina_l = 38.5;          // published 38.3 x 31.7 x 3 mm PCB
ina_w = 32.0;
ina_h =  8.0;          // PCB + parts + header allowance

/* [CN3791 MPPT — common mini module] */
mppt_l = 45.0;         // 45 x 20 x 9.5 mm typical
mppt_w = 20.0;
mppt_h = 10.0;

/* [Structure] */
wall             = 2.0;
partition        = 1.6;
xy_clear         = 0.15;  // designed tight print clearance (PETG / ASA)
board_side_clear = 0.8;
board_gap        = 2.5;   // Seeed-to-power-stack gap
sma_relief       = 8.0;   // inner clearance at SMA nut / pigtail
pg7_relief       = 8.0;   // inner clearance at PG7 lock nut
top_clear        = 2.0;   // air above tallest component
floor_t          = 2.0;
lid_t            = 2.2;
ina_air          = 2.0;   // air between MPPT top and INA underside

/* [Seal — 2.0 mm silicone cord, 22% compression] */
cord_d       = 2.0;    // silicone cord diameter, mm
cord_comp    = 0.22;   // 22% (design range 20–25%)
groove_w     = 2.40;   // ~85% gland fill when closed
inner_land   = 1.20;   // cavity edge to O-ring groove
mid_land     = 1.10;   // O-ring to tongue groove
tongue_w     = 1.30;
tongue_h     = 2.20;
tongue_clear = 0.15;   // radial, each side
outer_lip    = 1.50;
groove_cl_r  = 4.50;   // O-ring CENTERLINE corner radius (min ~2 x cord_d)
drip_lip     = 1.10;   // lid rain-lip radial overhang
drip_hang    = 2.00;   // lid rain-lip drop
drip_gap     = 0.25;   // rain-lip radial clearance over the box

/* [M3 lid screws + heat-set inserts, OUTSIDE the seal] */
insert_d       = 4.00; // bore for M3 heat-set (Ruthex M3x5.7 / standard)
insert_depth   = 6.00;
insert_boss_d  = 8.80;
screw_clear_d  = 3.30;
screw_head_d   = 6.20;
screw_head_h   = 0.80; // shallow spot-face; head may sit slightly proud
screw_off      = 7.10; // cavity edge to screw axis (outside O-ring)

/* [PG7 cable gland] */
pg7_hole     = 12.60;  // 12.5 mm nominal + 0.10 print
pg7_boss_t   =  3.00;  // finished wall at the hole (typical PG7 max panel 3 mm)
pg7_seat_od  = 18.00;  // flat washer / O-ring seat
pg7_clear_od = 20.00;  // foot cutout around the gland body

/* [SMA bulkhead] */
sma_hole       = 6.50;
sma_flat       = 5.80;  // D-flat (Linx / typical SMA bulkhead)
sma_seat_od    = 10.50; // flat O-ring seat (covers typical 9.1 mm O-ring OD)
sma_seat_depth =  0.40;
sma_wall       =  2.40; // finished wall, under the 2.50 mm SMA nut limit
sma_boss_od    = 12.00;
sma_nut_clear  = 12.00; // inner counterbore for the hex nut

/* [Foot — 45° fixed wedge, separate part] */
foot_run         = 18.0;  // equal rise/run at 45°, mm
foot_plate       =  4.0;  // mating-plate thickness
foot_insert_d    =  4.00;
foot_insert_depth=  4.50;
foot_pad_h       =  5.00; // external pad (blind inserts, do not break through)
foot_screw_clear =  3.30;
foot_screw_head_d=  6.20;

/* [Hidden] */
eps = 0.06;
$fn = 48;

// ---------------------------------------------------------------------------
// Derived dimensions
// ---------------------------------------------------------------------------
groove_d     = cord_d * (1 - cord_comp);          // 1.56 mm at 22%
tongue_gw    = tongue_w + 2*tongue_clear;         // 1.60
flange_w     = inner_land + groove_w + mid_land + tongue_gw + outer_lip;

pocket_x     = bat_l + 2*bat_clear_l;
pocket_y     = bat_t + bat_clear_t;
pocket_z     = bat_w + bat_clear_w;

center_y     = max(ina_w, mppt_w, seeed_w) + 2*board_side_clear;
power_x      = max(ina_l, mppt_l) + 1.0;
seeed_need_x = seeed_l + 1.2;

inner_x      = pg7_relief + power_x + board_gap + seeed_need_x + sma_relief;
inner_y      = pocket_y + partition + center_y + partition + pocket_y;

ina_ledge_z  = floor_t + mppt_h + ina_air;
ina_top      = ina_ledge_z + ina_h;
inner_z      = max(seeed_h, ina_top - floor_t, pocket_z) + top_clear;

flange_z     = floor_t + inner_z;                 // mating face
box_h        = flange_z;

body_x       = inner_x + 2*flange_w;
body_y       = inner_y + 2*flange_w;
body_r       = 5.0;

cl_x         = inner_x + 2*(inner_land + groove_w/2);
cl_y         = inner_y + 2*(inner_land + groove_w/2);
cl_r         = groove_cl_r;
cord_len     = 2*(cl_x - 2*cl_r) + 2*(cl_y - 2*cl_r) + 2*PI*cl_r;

tn_x         = inner_x + 2*(inner_land + groove_w + mid_land + tongue_gw/2);
tn_y         = inner_y + 2*(inner_land + groove_w + mid_land + tongue_gw/2);
tn_r         = cl_r + (tn_x - cl_x)/2;

screw_x      = inner_x/2 + screw_off;
screw_y      = inner_y/2 + screw_off;

boss_out_x   = 2*(screw_x + insert_boss_d/2 + 0.4);
boss_out_y   = 2*(screw_y + insert_boss_d/2 + 0.4);
outer_x      = max(body_x, boss_out_x);
outer_y      = max(body_y, boss_out_y);

lid_x        = outer_x + 2*drip_lip;
lid_y        = outer_y + 2*drip_lip;
lid_r        = body_r + drip_lip;

// -X = PG7 / foot / low end;  +X = SMA / high end
x_power_mid  = -inner_x/2 + pg7_relief + power_x/2;
x_seeed_mid  =  inner_x/2 - sma_relief - seeed_need_x/2;
x_bat_mid    =  x_power_mid;

pg7_z        = max(floor_t + pg7_hole/2 + 2.2, 11.0);
sma_z        = floor_t + inner_z*0.52;

foot_pad_z   = min(flange_z - 6.5, pg7_z + pg7_hole/2 + 6.5);
foot_pad_y   = inner_y/2 - 4.0;
foot_pad_r   = 5.2;

closed_h     = box_h + lid_t;

pg7_boss_out = 0.8;                         // extra outer seat proud of the wall
sma_boss_out = max(0, sma_wall - wall) + 0.6;
pg7_outer_x  = -body_x/2 - pg7_boss_out;    // outer seat face
sma_outer_x  =  body_x/2 + sma_boss_out;

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------
module rr2d(x, y, r) {
    r2 = min(r, x/2 - 0.05, y/2 - 0.05);
    offset(r = r2) offset(r = -r2)
        square([x, y], center = true);
}

module rr_prism(x, y, h, r, z=0) {
    translate([0, 0, z])
        linear_extrude(height = h)
            rr2d(x, y, r);
}

module ring2d(cx, cy, cr, width) {
    difference() {
        offset(delta =  width/2) rr2d(cx, cy, cr);
        offset(delta = -width/2) rr2d(cx, cy, cr);
    }
}

module sma_d_hole(h, d=sma_hole, flat=sma_flat) {
    // Ød with a flat such that the D-height is `flat` (typical 6.50 / 5.80)
    intersection() {
        cylinder(h = h, d = d, center = true);
        translate([0, (flat - d)/2, 0])
            cube([d + 2, flat, h + 1], center = true);
    }
}

module insert_bore(depth, d=insert_d) {
    union() {
        translate([0, 0, -depth])
            cylinder(h = depth + eps, d = d);
        translate([0, 0, -0.7])
            cylinder(h = 0.7 + eps, d1 = d, d2 = d + 1.0);
    }
}

function screw_pts() = [
    [ screw_x,  screw_y],
    [ screw_x, -screw_y],
    [-screw_x,  screw_y],
    [-screw_x, -screw_y]
];

function foot_pad_pts() = [
    [0,  foot_pad_y],
    [0, -foot_pad_y]
];

// ---------------------------------------------------------------------------
// BOX solids
// ---------------------------------------------------------------------------
module corner_bosses(h) {
    for (p = screw_pts()) {
        hull() {
            translate([p[0], p[1], 0])
                cylinder(h = h, d = insert_boss_d + 0.8);
            translate([p[0] - sign(p[0])*insert_boss_d,
                       p[1] - sign(p[1])*insert_boss_d, 0])
                cylinder(h = h, d = 2);
        }
    }
}

module box_solid() {
    rr_prism(body_x, body_y, box_h, body_r);
    corner_bosses(box_h);

    // PG7 outer seat (flat washer face), proud of the -X wall
    translate([pg7_outer_x, 0, pg7_z])
        rotate([0, 90, 0])
            cylinder(h = pg7_boss_out + eps, d = pg7_seat_od);

    // SMA outer boss, proud of the +X wall, carries the O-ring seat
    translate([body_x/2 - eps, 0, sma_z])
        rotate([0, 90, 0])
            cylinder(h = sma_boss_out + eps, d = sma_boss_od);

    // Foot-mount pads on the -X outer face (blind inserts live here)
    for (p = foot_pad_pts())
        translate([-body_x/2, p[1], foot_pad_z])
            rotate([0, -90, 0])
                cylinder(h = foot_pad_h, d = foot_pad_r*2);
}

module box_cavity() {
    translate([0, 0, floor_t])
        rr_prism(inner_x, inner_y, inner_z + eps, 2.5);
}

// INA ledge: 45° underside, printable with the box sitting panel-face down.
// Called in a frame whose origin is on the PARTITION INNER FACE,
// at the floor, with +Y pointing out of the wall into the center? We pass `dir`.
module ina_ledge(length, width, top_z, dir) {
    // Always built growing in +Y with consistent face winding, then
    // mirrored if the ledge must grow in -Y. Avoids an inside-out polyhedron.
    L = length/2;
    t = 1.6;
    w = width;
    points = [
        [-L, 0, top_z],            // 0
        [ L, 0, top_z],            // 1
        [ L, w, top_z],            // 2
        [-L, w, top_z],            // 3
        [-L, w, top_z - t],        // 4
        [ L, w, top_z - t],        // 5
        [ L, 0, top_z - t - width],// 6
        [-L, 0, top_z - t - width] // 7
    ];
    faces = [
        [0, 1, 2], [0, 2, 3],
        [3, 2, 5], [3, 5, 4],
        [0, 3, 4], [0, 4, 7],
        [1, 6, 5], [1, 5, 2],
        [4, 5, 6], [4, 6, 7],
        [0, 7, 6], [0, 6, 1]
    ];
    mirror([0, dir < 0 ? 1 : 0, 0])
        polyhedron(points = points, faces = faces);
}

module partitions() {
    part_x = max(pocket_x, power_x) + 2.0;
    part_h = inner_z - 0.30;            // 0.3 mm lid clearance
    y_off  = center_y/2 + partition/2;
    // Lead slot, PG7 / PCM end of each pocket — kept clear of the INA ledge
    slot_cx = x_bat_mid - pocket_x/2 + 4.0;
    slot_w  = 8.0;
    ledge_len = power_x - 8.0;          // shortened so it stays clear of the slot

    for (s = [-1, 1]) {
        difference() {
            translate([x_bat_mid, s*y_off, floor_t + part_h/2])
                cube([part_x, partition, part_h], center = true);
            translate([slot_cx, s*y_off, floor_t + 4.0 + box_h/2])
                cube([slot_w, partition + 2.0, box_h], center = true);
        }
        // INA ledges — separate from the slot difference, both sides identical
        translate([x_power_mid + 2.0, s*(center_y/2), floor_t])
            ina_ledge(ledge_len, 2.0, ina_ledge_z - floor_t, -s);
        // End-stop at the SMA-ward end of each battery pocket
        translate([x_bat_mid + pocket_x/2 + 0.8,
                   s*(center_y/2 + partition + pocket_y/2),
                   floor_t + (pocket_z*0.45)/2])
            cube([1.6, pocket_y + 0.2, pocket_z*0.45], center = true);
    }
}

module floor_pockets() {
    translate([x_power_mid, 0, floor_t - 1.0])
        rr_prism(mppt_l + 0.6, mppt_w + 0.6, 1.0 + eps, 1.0);
    translate([x_seeed_mid, 0, floor_t - 1.0])
        rr_prism(seeed_l + 0.7, seeed_w + 0.7, 1.0 + eps, 1.0);
}

module seal_grooves() {
    translate([0, 0, box_h - groove_d])
        linear_extrude(height = groove_d + eps)
            ring2d(cl_x, cl_y, cl_r, groove_w);
    translate([0, 0, box_h - (tongue_h + 0.25)])
        linear_extrude(height = tongue_h + 0.25 + eps)
            ring2d(tn_x, tn_y, tn_r, tongue_gw);
}

module end_holes() {
    // --- PG7 ---
    // Through-hole
    translate([pg7_outer_x - 2, 0, pg7_z])
        rotate([0, 90, 0])
            cylinder(h = 30, d = pg7_hole);
    // Inner counterbore: leave only pg7_boss_t of wall, so a standard
    // PG7 (max panel ~3 mm, thread ~9 mm) can take a lock nut.
    translate([pg7_outer_x + pg7_boss_t, 0, pg7_z])
        rotate([0, 90, 0])
            cylinder(h = flange_w + 4, d = pg7_seat_od - 1.0);

    // --- SMA ---
    // D-hole, flat toward the panel (‑Z in this rotation)
    translate([sma_outer_x + 2, 0, sma_z])
        rotate([0, 90, 0])
            rotate([0, 0, 90])
                sma_d_hole(h = 30);
    // Flat O-ring seat: shallow counterbore on the OUTSIDE
    translate([sma_outer_x - sma_seat_depth, 0, sma_z])
        rotate([0, 90, 0])
            cylinder(h = sma_seat_depth + 1.0, d = sma_seat_od);
    // Inner counterbore: leave only sma_wall (2.4 mm) for the bulkhead nut
    translate([sma_outer_x - sma_wall, 0, sma_z])
        rotate([0, -90, 0])
            cylinder(h = flange_w + 4, d = sma_nut_clear);
}

module lid_insert_holes() {
    for (p = screw_pts())
        translate([p[0], p[1], box_h])
            insert_bore(insert_depth, insert_d);
}

module foot_insert_holes() {
    for (p = foot_pad_pts())
        translate([-body_x/2 - foot_pad_h, p[1], foot_pad_z])
            rotate([0, 90, 0])
                union() {
                    cylinder(h = foot_insert_depth + eps, d = foot_insert_d);
                    cylinder(h = 0.7, d1 = foot_insert_d + 1.0, d2 = foot_insert_d);
                }
}

module box() {
    difference() {
        box_solid();
        box_cavity();
        seal_grooves();
        end_holes();
        lid_insert_holes();
        foot_insert_holes();
        floor_pockets();
    }
    // Partitions, ledges and battery end-stops added back into the cavity
    partitions();
}

// ---------------------------------------------------------------------------
// LID  (modeled with underside at z = 0, outer face at z = lid_t;
//       tongue and drip lip extend into -Z. Print flipped, outer face down.)
// ---------------------------------------------------------------------------
module lid_inner_cut_2d() {
    union() {
        rr2d(body_x, body_y, body_r);
        for (p = screw_pts())
            translate([p[0], p[1]])
                circle(d = insert_boss_d + 0.8);
    }
}

module lid() {
    difference() {
        union() {
            rr_prism(lid_x, lid_y, lid_t, lid_r);
            corner_bosses(lid_t);

            // Drip / rain lip
            difference() {
                translate([0, 0, -drip_hang])
                    rr_prism(lid_x, lid_y, drip_hang + eps, lid_r);
                translate([0, 0, -drip_hang - eps])
                    linear_extrude(height = drip_hang + 3*eps)
                        offset(delta = drip_gap)
                            lid_inner_cut_2d();
            }

            // Tongue
            translate([0, 0, -tongue_h])
                linear_extrude(height = tongue_h + eps)
                    ring2d(tn_x, tn_y, tn_r, tongue_w);

            // Battery hold-down ribs (0.4 mm of free space above the cell)
            rib_h = max(0.8, (floor_t + inner_z) - (floor_t + pocket_z) - 0.4);
            for (s = [-1, 1]) {
                y = s * (center_y/2 + partition + pocket_y/2);
                translate([x_bat_mid, y, -min(rib_h, 4.5)])
                    rr_prism(pocket_x - 4, max(1.6, pocket_y - 1.4),
                             min(rib_h, 4.5) + eps, 0.8);
            }
        }
        // Rain-lip clearance at the foot (-X) end so the foot plate
        // can sit flush against the wall. Cuts only the hanging lip.
        translate([-lid_x/2, 0, -drip_hang/2])
            cube([(lid_x - body_x) + 3.0,
                  body_y - 0.4,
                  drip_hang + 2*eps], center = true);

        // M3 through-holes + shallow outer spot-face
        for (p = screw_pts()) {
            translate([p[0], p[1], -drip_hang - 1])
                cylinder(h = lid_t + drip_hang + 2, d = screw_clear_d);
            translate([p[0], p[1], lid_t - screw_head_h])
                cylinder(h = screw_head_h + 1, d = screw_head_d);
        }
        // Outer-face label
        translate([0, body_y/2 - 8, lid_t - 0.35])
            linear_extrude(height = 0.5)
                text("SOLAR NODE", size = 3.6,
                     font = "Liberation Sans:style=Bold",
                     halign = "center", valign = "center");
    }
}

module lid_printable() {
    translate([0, 0, lid_t])
        rotate([180, 0, 0])
            lid();
}

// ---------------------------------------------------------------------------
// FOOT  — 45° wedge. Mating face is the plane x = -body_x/2.
// Ground plane through the panel-face lower edge, at 45°:
//     z = -(x - (-body_x/2))    (in box coordinates)
// Mount the box with this (PG7) end at or below the panel's lower edge.
// ---------------------------------------------------------------------------
module foot() {
    fw = body_y - 2.0;
    z0 = 0.2;
    z1 = min(box_h - 0.4, max(foot_run + 3.0, foot_pad_z + foot_pad_r + 2.0));

    difference() {
        union() {
            // Mating plate against the -X wall
            translate([-body_x/2 - foot_plate, -fw/2, z0])
                cube([foot_plate, fw, z1 - z0]);
            // Wedge block (cut to 45° below)
            translate([-body_x/2 - foot_plate - foot_run, -fw/2, z0])
                cube([foot_run, fw, z1 - z0]);
        }

        // PG7 gland clearance: cylinder + U-slot toward the panel face
        translate([-body_x/2 + 1, 0, pg7_z])
            rotate([0, -90, 0])
                cylinder(h = foot_run + foot_plate + 6, d = pg7_clear_od);
        translate([-body_x/2 - (foot_run + foot_plate)/2 - 1, 0, pg7_z/2])
            cube([foot_run + foot_plate + 6, pg7_clear_od, pg7_z + 2], center = true);

        // M3 through-holes and cap pockets (from the heel side)
        for (p = foot_pad_pts()) {
            translate([-body_x/2 - foot_plate - foot_run - 2, p[1], foot_pad_z])
                rotate([0, 90, 0])
                    cylinder(h = foot_plate + foot_run + 6, d = foot_screw_clear);
            translate([-body_x/2 - foot_plate - 0.8, p[1], foot_pad_z])
                rotate([0, -90, 0])
                    cylinder(h = foot_run + 2, d = foot_screw_head_d);
        }

        // Locating recesses for the box pads (0.15 mm fit)
        for (p = foot_pad_pts())
            translate([-body_x/2 + eps, p[1], foot_pad_z])
                rotate([0, -90, 0])
                    cylinder(h = foot_pad_h + 0.15, d = foot_pad_r*2 + 0.25);

        // 45° ground-plane cut
        translate([-body_x/2, 0, 0])
            rotate([0, 45, 0])
                translate([-90, -90, -180])
                    cube([180, 180, 180]);
    }
}

module foot_printable() {
    // Mating face on the bed, foot growing +Z. 45° face is a 45° overhang
    // (printable without supports).
    rotate([0, 90, 0])
        translate([body_x/2, 0, 0])
            foot();
}

// ---------------------------------------------------------------------------
// Preview ghosts (not in the printable STLs)
// ---------------------------------------------------------------------------
module ghost_parts() {
    for (s = [-1, 1]) {
        y = s * (center_y/2 + partition + pocket_y/2);
        color("#D4A017", 0.88)
            translate([x_bat_mid, y, floor_t + bat_w/2 + 0.3])
                cube([bat_l, bat_t, bat_w], center = true);
    }
    color("#C45C26", 0.88)
        translate([x_power_mid, 0, floor_t + mppt_h/2])
            cube([mppt_l, mppt_w, mppt_h], center = true);
    color("#2E8B57", 0.88)
        translate([x_power_mid, 0, ina_ledge_z + ina_h/2])
            cube([ina_l, ina_w, ina_h], center = true);
    color("#2F6FED", 0.88)
        translate([x_seeed_mid, 0, floor_t + seeed_h/2])
            cube([seeed_l, seeed_w, seeed_h], center = true);

    // O-ring, proud of the flange by (cord_d - groove_d)
    color("#1A1A1A", 0.95)
        oring_ghost();
}

module oring_ghost() {
    cr = cl_r;
    sx = cl_x/2 - cr;
    sy = cl_y/2 - cr;
    d  = cord_d;
    z  = box_h - groove_d + d/2;
    for (rot = [0, 180])
        rotate([0, 0, rot])
            translate([0, cl_y/2, z])
                rotate([90, 0, 90])
                    cylinder(h = cl_x - 2*cr, d = d, center = true);
    for (rot = [90, 270])
        rotate([0, 0, rot])
            translate([0, cl_x/2, z])
                rotate([90, 0, 90])
                    cylinder(h = cl_y - 2*cr, d = d, center = true);
    angs = [[ 1,  1,  0], [ -1,  1, 90], [ -1, -1, 180], [ 1, -1, 270]];
    for (a = angs)
        translate([a[0]*sx, a[1]*sy, z])
            rotate([0, 0, a[2]])
                rotate_extrude(angle = 90)
                    translate([cr, 0, 0])
                        circle(d = d);
}

module assembly(expl = 0, ghosts = false) {
    color("#3D4A3D") box();
    color("#5A6B5A")
        translate([0, 0, box_h + expl])
            lid();
    color("#3D4A3D")
        translate([-expl * 0.65, 0, 0])
            foot();
    if (ghosts) ghost_parts();
}

// ---------------------------------------------------------------------------
// Dimension echo
// ---------------------------------------------------------------------------
module print_dims() {
    echo(str("inner_x=", inner_x));
    echo(str("inner_y=", inner_y));
    echo(str("inner_z=", inner_z));
    echo(str("body_x=", body_x));
    echo(str("body_y=", body_y));
    echo(str("box_h=", box_h));
    echo(str("outer_x=", outer_x));
    echo(str("outer_y=", outer_y));
    echo(str("lid_x=", lid_x));
    echo(str("lid_y=", lid_y));
    echo(str("closed_h=", closed_h));
    echo(str("flange_w=", flange_w));
    echo(str("groove_d=", groove_d));
    echo(str("groove_w=", groove_w));
    echo(str("cord_d=", cord_d));
    echo(str("cord_comp=", cord_comp));
    echo(str("cord_len=", cord_len));
    echo(str("cl_x=", cl_x));
    echo(str("cl_y=", cl_y));
    echo(str("cl_r=", cl_r));
    echo(str("tn_x=", tn_x));
    echo(str("tn_y=", tn_y));
    echo(str("tn_r=", tn_r));
    echo(str("tongue_w=", tongue_w));
    echo(str("tongue_h=", tongue_h));
    echo(str("tongue_gw=", tongue_gw));
    echo(str("screw_x=", screw_x));
    echo(str("screw_y=", screw_y));
    echo(str("insert_d=", insert_d));
    echo(str("insert_depth=", insert_depth));
    echo(str("pg7_hole=", pg7_hole));
    echo(str("pg7_z=", pg7_z));
    echo(str("pg7_boss_t=", pg7_boss_t));
    echo(str("pg7_outer_x=", pg7_outer_x));
    echo(str("sma_hole=", sma_hole));
    echo(str("sma_flat=", sma_flat));
    echo(str("sma_z=", sma_z));
    echo(str("sma_seat_od=", sma_seat_od));
    echo(str("sma_seat_depth=", sma_seat_depth));
    echo(str("sma_wall=", sma_wall));
    echo(str("sma_outer_x=", sma_outer_x));
    echo(str("foot_run=", foot_run));
    echo(str("foot_plate=", foot_plate));
    echo(str("pocket_x=", pocket_x));
    echo(str("pocket_y=", pocket_y));
    echo(str("pocket_z=", pocket_z));
    echo(str("center_y=", center_y));
    echo(str("power_x=", power_x));
    echo(str("ina_ledge_z=", ina_ledge_z));
    echo(str("floor_t=", floor_t));
    echo(str("lid_t=", lid_t));
    echo(str("wall=", wall));
    echo(str("bat_l=", bat_l));
    echo(str("bat_w=", bat_w));
    echo(str("bat_t=", bat_t));
    echo(str("seeed_l=", seeed_l));
    echo(str("seeed_w=", seeed_w));
    echo(str("seeed_h=", seeed_h));
    echo(str("ina_l=", ina_l));
    echo(str("ina_w=", ina_w));
    echo(str("ina_h=", ina_h));
    echo(str("mppt_l=", mppt_l));
    echo(str("mppt_w=", mppt_w));
    echo(str("mppt_h=", mppt_h));
    echo(str("x_power_mid=", x_power_mid));
    echo(str("x_seeed_mid=", x_seeed_mid));
    echo(str("x_bat_mid=", x_bat_mid));
    echo(str("foot_pad_z=", foot_pad_z));
    echo(str("foot_pad_y=", foot_pad_y));
    echo(str("drip_lip=", drip_lip));
    echo(str("drip_hang=", drip_hang));
    echo(str("xy_clear=", xy_clear));
    echo(str("body_r=", body_r));
    echo(str("pg7_boss_out=", pg7_boss_out));
    echo(str("sma_boss_out=", sma_boss_out));
}

print_dims();

module sitting() {
    // Rest the 45° foot face on the XY plane (z = 0 is the ground).
    // Pivot is the panel-face lower edge.
    rotate([0, 45, 0])
        translate([body_x/2, 0, 0])
            assembly(expl = 0, ghosts = false);
}

module cutaway() {
    difference() {
        assembly(expl = 0, ghosts = true);
        // Cut the near half so the seal and layout are visible
        translate([0, -80, 0])
            cube([240, 160, 160], center = true);
    }
}

if      (part == "box")       box();
else if (part == "lid")        lid_printable();
else if (part == "foot")       foot_printable();
else if (part == "assembly")   assembly(expl = 0, ghosts = false);
else if (part == "preview")    assembly(expl = explode, ghosts = true);
else if (part == "sitting")    sitting();
else if (part == "cutaway")    cutaway();
else if (part == "dims")       { }
