from manim import *
import numpy as np

class VolumeFlowGraph(Scene):
    def construct(self):
        # Define Axes
        axes = Axes(
            x_range=[-3, 3, 1],  # Volume (L)
            y_range=[-2, 2, 1],   # Flow (L/s)
            axis_config={"color": WHITE}
        ).add_coordinates()

        # Labels
        x_label = axes.get_x_axis_label("Volume (L)", direction=DOWN)
        y_label = axes.get_y_axis_label("Flow (L/s)", direction=LEFT)

        # Define Flow Function: Sinusoidal for breathing cycle
        def flow_function(x):
            return np.sin(2 * np.pi * x)

        # Create Graph
        graph = axes.plot(flow_function, color=BLUE)

        # Animated Breathing Indicator (Dot moving along the graph)
        dot = Dot(color=YELLOW).move_to(axes.c2p(-3, flow_function(-3)))  # Start at leftmost point

        # Move dot along the graph
        def update_dot(mob, dt):
            mob.shift(RIGHT * dt * 2)  # Move right
            x_val = axes.p2c(mob.get_center())[0]
            if x_val > 3:
                mob.move_to(axes.c2p(-3, flow_function(-3)))  # Reset position
            else:
                mob.move_to(axes.c2p(x_val, flow_function(x_val)))

        dot.add_updater(update_dot)

        # Animate
        self.play(Create(axes), Write(x_label), Write(y_label))
        self.play(Create(graph), FadeIn(dot))
        self.wait(6)  # Let animation run for a few cycles
