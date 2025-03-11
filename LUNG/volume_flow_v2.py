from manim import *
import numpy as np

class FlowVolumeLoop(Scene):
    def construct(self):
        # Define Axes
        axes = Axes(
            x_range=[0, 4, 1],  # Volume (L)
            y_range=[-4, 6, 2],  # Flow (L/s)
            axis_config={"color": WHITE}
        ).add_coordinates()

        # Labels
        x_label = axes.get_x_axis_label("Volume (L)", direction=UP * 2)
        y_label = axes.get_y_axis_label("Flow (L/s)", direction=LEFT + 1)

        # Define Flow-Volume Loop Functions
        def exp_flow(x):  # Expiration phase
            return 20 * np.exp(-x) * np.sin(np.pi * x / 3)
        
        def insp_flow(x):  # Inspiration phase
            return -4 * np.sin(np.pi * x / 3)

        # Create Graphs for Expiration and Inspiration
        exp_curve = axes.plot(exp_flow, x_range=[0, 3], color=RED)
        insp_curve = axes.plot(insp_flow, x_range=[0, 3], color=BLUE)

        # Animated Dot
        dot = Dot(color=YELLOW).move_to(axes.c2p(0, exp_flow(0)))

        # Animation Path
        exp_path = VMobject()
        exp_points = [axes.c2p(x, exp_flow(x)) for x in np.linspace(0, 3, 50)]
        exp_path.set_points_smoothly(exp_points)

        insp_path = VMobject()
        insp_points = [axes.c2p(x, insp_flow(x)) for x in np.linspace(3, 0, 50)]
        insp_path.set_points_smoothly(insp_points)

        # Dot Movement Along Expiration & Inspiration Path
        exp_animation = MoveAlongPath(dot, exp_path, run_time=2)  # 2 sec expiration
        insp_animation = MoveAlongPath(dot, insp_path, run_time=2)  # 2 sec inspiration

        # Animate
        self.play(Create(axes), Write(x_label), Write(y_label), run_time = 0.5)
        self.play(Create(exp_curve), Create(insp_curve), run_time = 0.5)
        self.play(FadeIn(dot), run_time = 0.5)

        # Loop animation for continuous breathing cycle
        self.play(exp_animation, run_time = 2)
        self.play(insp_animation, run_time = 2)
        self.play(exp_animation, run_time = 2)
        self.play(insp_animation, run_time = 2)
        
        
