# Wireless UHF RFID-based Bladder Pressure Sensor

Final project for the **Wearable Systems and Medical Telemetry** course (*Sistemi Wearable e Telemetria Medica*, A.Y. 2024/2025)  
Pervasive Electromagnetics Lab – Prof. G. Marrocco – Tutor: Eng. Francesca Nanni

**Team:** Domiziana Berardino, Alice Bonucci, Antonio Giordano, Valerio Luzi, Silvia Gialloreto

Design, simulation and prototyping of a **passive UHF RFID tag (RAIN RFID, 915 MHz)** to be implanted on the outer wall of the bladder. The tag is meant to monitor bladder strain and pressure wirelessly, as an alternative to catheter-based cystometry, which is invasive, uncomfortable and carries a risk of infection.

---

## Repository structure

```
rfid-intravesical-pressure/
├── cst/                          # CST Studio Suite projects (keep each .cst next to its folder)
│   ├── dipolo_design.cst  + dipolo_design/     # dipole with circular encapsulation
│   ├── dipolo_ellisse.cst + dipolo_ellisse/    # dipole with elliptical-cylinder encapsulation
│   └── dip_ellisse_chip.cst + dip_ellisse_chip/  # final design: dipole + chip footprint + matching inductor
├── matlab/
│   ├── formuleAnja.m             # radiation efficiency vs body radius (rbody)
│   ├── FormuleAnjaRIMPL.m        # radiation efficiency vs implant radius (rimpl)
│   └── calcolo mag.m             # MAG and link gain from the S-matrix + Pav,g boxplot
└── docs/
    ├── PROGETTO 2025 wearable.pdf        # project brief (phases 1–7)
    ├── Diagramma di Gantt wearable.xlsx  # activity planning
    ├── video wearable.mp4                # project video
    └── presentazioni/
        ├── presentazione 0 wearable.pptx        # WBS and Gantt
        ├── presentazione task 1 wearable.pptx   # state of the art, implant sites, pressure range
        ├── presentazione formule anya.pptx      # task 2: theoretical EM efficiency models
        ├── slide_task3_cst.pptx                 # task 3: CST spherical model and link budget
        ├── task_6.pptx                          # task 6: final design and matching
        ├── Task unione.pptx                     # task 6.1: models, encapsulation, simulations
        └── Presentazione Finale Wearable.pptx   # complete final presentation
```

---

## Project phases

### 1. Biomedical analysis
- **State of the art:** battery-powered RF telemetry (433 MHz), NFC-like inductive systems (*Bladder Pill*), hybrid systems, implantable strain sensors.
- **Pressure range:** filling ~10–20 cmH₂O, voiding ~80–100 cmH₂O, pathological conditions > 150 cmH₂O.
- **Implantation:** by **laparoscopy** (device ~30 × 15 mm, compatible with trocars) or, as a more invasive alternative, by suprapubic laparotomy.

### 2. Theoretical EM model – `matlab/formuleAnja.m`, `matlab/FormuleAnjaRIMPL.m`
These scripts implement the formulas from *Gao, Nikolayev, Sipus, Skrivervik – "Physical Insights into Electromagnetic Efficiency of Wireless Implantable Bioelectronics"*. The total efficiency η<sub>total</sub> of a TE/TM source implanted in a spherical body is the product of three losses: near-field, propagation and reflection at the body-air interface. The dielectric properties of the tissues (bladder, fat, skin, urine) are evaluated at 900–915 MHz.

| Model (floating device) | η<sub>tot</sub> TE source | η<sub>tot</sub> TM source |
|---|---|---|
| Uniform body (arithmetic mean) | −21.7 dB | −25.6 dB |
| Layered body (arithmetic mean) | −24 dB | −27.7 dB |

### 3. Link budget on a CST spherical model – `matlab/calcolo mag.m`
The model is spherical and layered: skin, fat, muscle, bladder wall, and urine or air. The tag is a short implanted dipole and the reader is a slot antenna on the abdominal skin. The **Maximum Available Gain (MAG)** is derived from the S-parameters, together with the minimum power the reader must deliver, P<sub>av,g</sub> = p<sub>s</sub> / MAG, for chip sensitivities p<sub>s</sub> = −13 dBm and −16 dBm.

| MAG [dB] (no muscle) | Underweight | Normal weight | Overweight |
|---|---|---|---|
| Empty bladder | −21.5 | −24.4 | −30.0 |
| 50% urine / 50% air | −30.3 | −32.9 | −38.5 |
| Full bladder | −33.7 | −36.5 | −42.2 |

With the muscle layer (normal weight), the MAG is −28.4 dB with an empty bladder, −37.7 dB at 50% and −39.7 dB with a full bladder.

### 4. Chip and antenna selection
- **Chip:** Asygn **AS3213S_5** with integrated strain sensor, Z<sub>chip</sub> (915 MHz) = 30 − j195 Ω, sensitivity −13 dBm.
- **Geometry comparison:** dipole RX / slot TX, loop RX / slot TX, loop RX / loop TX. The dipole has the better MAG but an impedance that is harder to match. The loop's impedance is more stable as the bladder filling changes.

### 5. Antenna design and encapsulation – `cst/`
Tag stack, from the bottom: silicone (1 mm) → Kapton (0.125 mm) → tag copper (0.035 mm) → low-ε layer (h<sub>impl</sub>), all wrapped in Tegaderm.

| CST project | Content | Main parameters |
|---|---|---|
| `dipolo_design` | dipole with circular encapsulation (R = 30 mm) | L = 14 mm, W = 1.5 mm, h<sub>impl</sub> = 3.5 mm |
| `dipolo_ellisse` | elliptical-cylinder encapsulation, parametric sweeps on L, W and h<sub>impl</sub> | L = 27 mm, r<sub>max</sub> = L/2 + 1.5, r<sub>min</sub> = 7.5 mm |
| `dip_ellisse_chip` | **final design** with chip footprint and series inductor (`.s2p` block, Murata LQW15AN82NG00) | L = 27 mm, W = 1.5 mm, h<sub>impl</sub> = 2 mm, Ind = 85 nH |

The models include tissues with parametric radii (skin 93.5 mm, fat 91.5 mm, muscle 61.5 mm, bladder 51.5 mm, urine 41.5 mm) and are centred at f<sub>0</sub> = 915 MHz.

An **elliptical encapsulation (30 × 15 mm)** was chosen because it is compatible with laparoscopy, reduces stress points and is easy to suture. Impedance matching would ideally need a ~89 nH series inductor; the closest commercial value is **82 nH**.

**Final design results (915 MHz):**

| Scenario | τ (transmission coefficient) | G<sub>T</sub> (transducer gain) |
|---|---|---|
| Real bladder, 50% urine / 50% air | 0.92 | −30 dB |
| Latex balloon, 50/50 | 0.98 | −29.7 dB |
| Balloon, full | 0.97 | −30.2 dB |
| Balloon, empty | 0.17 | −35.3 dB |

In the real-bladder model the tag impedance (~20.6 − j317 Ω) does not change noticeably with the filling.

### 6. Prototyping and measurements
- **Fabrication:** milling with a 4MILL 300 ATC on copper/Kapton, soldering of the AS3213S_5 chip and of the 82 nH inductor, encapsulation in silicone, foam rubber and Tegaderm.
- **Setup:** a balloon filled with saline through a syringe to simulate filling and voiding, about 3 cm of fresh meat over the tag, and the slot reader placed on top.
- **Instruments:** Voyantic TagFormance UHF Pro (turn-on power, G<sub>T</sub>) and a ThingMagic M6e reader (strain measurement).
- **Results:** the measured G<sub>T</sub> peaks at a value similar to the simulated one, but shifted in frequency (885 MHz vs 915 MHz), probably because the permittivity of the meat is unknown. The strain variation read is minimal, because the balloon's radius of curvature changes little. The tag behaves almost like a *switch*: it responds when the balloon is deflated and stops responding when it is inflated.

### Future work
Medical-grade silicone foam instead of foam rubber, tests on ex vivo animal bladders, a silicone flange with suture holes (inspired by IPOM meshes) for laparoscopic fixation, and an anti-friction coating (Tegaderm or Parylene C).

---

## Requirements

- **CST Studio Suite** to open the projects in `cst/`. Each `.cst` file must stay in the same folder as its data folder of the same name.
- **MATLAB** for the scripts in `matlab/` (no extra toolboxes needed).

> The `ModelCache/`, `Temp/` and `Result/` subfolders of the CST projects are generated by the solver and can be rebuilt by re-running the simulation.
