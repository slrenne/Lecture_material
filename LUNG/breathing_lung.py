from manim import *

class BreathingLung(Scene):
    def construct(self):
        # Define Colors
        lung_color = BLUE
        bronchiole_color = RED

        # Create alveoli (circles)
        alveolus1 = Circle(radius=0.5, color=lung_color, fill_opacity=0.6).shift(LEFT * 1)
        alveolus2 = Circle(radius=0.5, color=lung_color, fill_opacity=0.6).shift(RIGHT * 1)

        # Create bronchioles (small rectangles)
        bronchiole1 = Rectangle(width=0.3, height=1, color=bronchiole_color, fill_opacity=0.6
                                ).next_to(alveolus1, UP, buff=0).shift(RIGHT * 0.4, DOWN * 0.4)
        bronchiole1.rotate(-0.75)                             
        bronchiole2 = Rectangle(width=0.3, height=1, color=bronchiole_color, fill_opacity=0.6
                                ).next_to(alveolus2, UP, buff=0).shift(LEFT * 0.4, DOWN * 0.4)
        bronchiole2.rotate(0.75)                             
        # Create main bronchus (larger rectangle)
        bronchus = Rectangle(width=0.7, height=2, color=bronchiole_color, fill_opacity=0.6)
        bronchus.shift(UP * 1.9)

        # Grouping the lung components
        lung_system = VGroup(alveolus1, alveolus2, bronchiole1, bronchiole2, bronchus)

        # Breathing Animation: Expand & Contract
        self.play(FadeIn(lung_system))
        for _ in range(2):  # Repeat 2 breath cycles
            self.play(alveolus1.animate.scale(1.3), alveolus2.animate.scale(1.3), run_time=1.5)
            self.play(alveolus1.animate.scale(1 / 1.3), alveolus2.animate.scale(1 / 1.3), run_time=1.5)

        #self.wait(2)
