from manim import *
import numpy as np

class RespiratoryCycle(Scene):
    def construct(self):
        # Title
        title = Text("Respiratory Cycle Animation").scale(0.7).to_edge(UP)
        self.play(Write(title))

        # --- Lung Structure ---
        # Trachea
        trachea = Line(UP * 1.5, ORIGIN)

        # Bronchioles
        left_bronchiole = Line(ORIGIN, DOWN * 1.5).shift(LEFT * 1)
        right_bronchiole = Line(ORIGIN, DOWN * 1.5).shift(RIGHT * 1)

        # Alveoli
        left_alveolus = Circle(radius=0.4, color=BLUE).next_to(left_bronchiole, DOWN)
        right_alveolus = Circle(radius=0.4, color=BLUE).next_to(right_bronchiole, DOWN)

        # Grouping lung structure
        lung_structure = VGroup(trachea, left_bronchiole, right_bronchiole, left_alveolus, right_alveolus)
        lung_structure.shift(LEFT * 3)

        # --- Volume vs. Flow Curve ---
        axes = Axes(
            x_range=[-1.5, 1.5, 0.5],
            y_range=[-2, 2, 0.5],
            x_length=5,
            y_length=3,
            axis_config={"color": WHITE},
        ).shift(RIGHT * 3)

        x_label = axes.get_x_axis_label("Volume")
        y_label = axes.get_y_axis_label("Flow")

        # Breathing curve (sinusoidal function)
        def breathing_curve(t):
            return np.sin(2 * np.pi * t)

        breathing_graph = always_redraw(
            lambda: axes.plot(
                lambda x: breathing_curve(x), 
                x_range=[-1.5, 1.5], 
                color=YELLOW
            )
        )

        # Animation Sequence
        self.play(Create(lung_structure))
        self.wait(1)
        self.play(Create(axes), Write(x_label), Write(y_label))
        self.play(Create(breathing_graph))
        
        # Breathing animation (alveolar expansion and contraction)
        def breathe(mob, alpha):
            scale_factor = 1 + 0.2 * np.sin(2 * np.pi * alpha)  # Simulate expansion/contraction
            mob.become(Circle(radius=0.4 * scale_factor, color=BLUE).move_to(mob.get_center()))

        breathing_cycle = AnimationGroup(
            UpdateFromAlphaFunc(left_alveolus, breathe),
            UpdateFromAlphaFunc(right_alveolus, breathe),
            run_time=4, rate_func=linear
        )

        # Animate multiple breaths
        for _ in range(3):
            self.play(breathing_cycle)

        self.wait(2)
