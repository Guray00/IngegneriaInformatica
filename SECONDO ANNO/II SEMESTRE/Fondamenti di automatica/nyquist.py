"""
Copyright (C) 2025 Andrea Covelli

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.
"""

import numpy as np
import sympy as sp
import matplotlib.pyplot as plt
from matplotlib.animation import FuncAnimation
from matplotlib.gridspec import GridSpec
from matplotlib.widgets import Button, Slider
from datetime import datetime

# Author: Andrea Covelli
# Course: Control Systems

class TransferFunction:
    def __init__(self):
        self.s = sp.Symbol('s')
        # Define symbolic transfer function
        self.G_symbolic = self._get_symbolic_tf()
        # Get poles once during initialization
        self._poles = None
        self._zeros = None
        # Create fast numeric function
        self._G_numeric = self._create_numeric_tf()
    
    def _get_symbolic_tf(self):
        """Define the transfer function symbolically - modify this method to change the transfer function"""
        k = 10  # gain
        return k * (self.s + 4) / (self.s**2 * (self.s + 3))  # Example: G(s) = (s+2)/(s*(s+1))    
    def _create_numeric_tf(self):
        """Create a vectorized numeric function for faster evaluation"""
        expr = sp.lambdify(self.s, self.G_symbolic, modules=['numpy'])
        return np.vectorize(expr)
    
    @property
    def poles(self):
        """Lazy evaluation of poles"""
        if self._poles is None:
            num, den = sp.fraction(self.G_symbolic)
            pole_solutions = sp.solve(den, self.s)
            self._poles = [complex(p.evalf()) for p in pole_solutions]
        return self._poles
    
    @property
    def zeros(self):
        """Lazy evaluation of zeros"""
        if self._zeros is None:
            num, den = sp.fraction(self.G_symbolic)
            zero_solutions = sp.solve(num, self.s)
            self._zeros = [complex(z.evalf()) for z in zero_solutions]
        return self._zeros
    
    def evaluate(self, s):
        """Fast numeric evaluation of G(s)"""
        return self._G_numeric(s)

class NyquistAnimator:
    def __init__(self):
        # Initialize transfer function once
        self.tf = TransferFunction()
        
        self.fig = plt.figure(figsize=(15, 8))
        self.gs = GridSpec(2, 2, height_ratios=[1, 0.1])
        self.ax1 = self.fig.add_subplot(self.gs[0, 0])  # s-domain plot
        self.ax2 = self.fig.add_subplot(self.gs[0, 1])  # G(s)-domain plot
        
        # Create buttons
        self.ax_toggle = plt.axes([0.2, 0.05, 0.1, 0.04])
        self.ax_clear = plt.axes([0.7, 0.05, 0.1, 0.04])
        self.ax_speed = plt.axes([0.35, 0.05, 0.3, 0.04])
        self.btn_toggle = Button(self.ax_toggle, 'Start')
        self.btn_clear = Button(self.ax_clear, 'Clear')
        self.speed_slider = Slider(
            ax=self.ax_speed,
            label='Speed',
            valmin=1,
            valmax=100,
            valinit=50,
            valstep=1
        )
        
        self.is_animating = False
        self.frame_num = 0
        self.animation_speed = 50
        
        # Calculate plot limits
        self.plot_scale = self.calculate_plot_scale()
        
        self.setup_plot()
        self.setup_path()
        self.setup_animation()
        self.setup_buttons()

    def calculate_plot_scale(self):
        # Calculate s-domain scale based on pole locations
        s_scale_poles = max([abs(p) for p in self.tf.poles]) if self.tf.poles else 0
        s_scale_zeros = max([abs(z) for z in self.tf.zeros]) if self.tf.zeros else 0
        s_scale = max(s_scale_poles, s_scale_zeros) * 2
        
        # First generate the Nyquist path points (similar to setup_path but without storing)
        R = s_scale
        r = R * 0.05  # Detour radius
        N_points = 500  # Points per segment
        N_points_curve = 2000  # Points for curved sections
        
        # Find imaginary axis poles
        jw_poles = [p for p in self.tf.poles if abs(p.real) < 1e-10]
        jw_poles.sort(key=lambda x: x.imag)
        
        path_segments = []
        current_y = 0
        
        # Handle origin pole
        if any(abs(p) < 1e-10 for p in self.tf.poles):
            theta = np.linspace(0, np.pi/2, N_points_curve)
            path_segments.append(r * np.exp(1j * theta))
            current_y = r
        
        # Positive imaginary axis with detours
        for pole in jw_poles:
            if pole.imag > 0:
                if current_y < pole.imag - r:
                    t = np.linspace(current_y, pole.imag - r, N_points)
                    path_segments.append(1j * t)
                theta = np.linspace(-np.pi/2, np.pi/2, N_points_curve)
                detour = pole.imag + r * np.exp(1j * theta)
                path_segments.append(detour)
                current_y = pole.imag + r
        
        # Path to R*j
        if current_y < R:
            t = np.linspace(current_y, R, N_points)
            path_segments.append(1j * t)
        
        # Semicircle at infinity
        theta = np.linspace(np.pi/2, -np.pi/2, N_points_curve)
        path_segments.append(R * np.exp(1j * theta))
        
        # Negative imaginary axis with detours
        current_y = -R
        for pole in reversed(jw_poles):
            if pole.imag < 0:
                if current_y < pole.imag - r:
                    t = np.linspace(current_y, pole.imag - r, N_points)
                    path_segments.append(1j * t)
                theta = np.linspace(-np.pi/2, np.pi/2, N_points_curve)
                detour = pole.imag + r * np.exp(1j * theta)
                path_segments.append(detour)
                current_y = pole.imag + r
        
        # Complete the path
        if current_y < -r:
            t = np.linspace(current_y, -r, N_points)
            path_segments.append(1j * t)
        
        if any(abs(p) < 1e-10 for p in self.tf.poles):
            theta = np.linspace(3*np.pi/2, 2*np.pi, N_points_curve)
            path_segments.append(r * np.exp(1j * theta))
        
        # Calculate G(s) for all path points
        path = np.concatenate(path_segments)
        G_values = [self.tf.evaluate(s) for s in path]
        
        # Calculate exact scale based on actual points that will be plotted
        max_real = max([abs(g.real) for g in G_values])
        max_imag = max([abs(g.imag) for g in G_values])
        G_scale = max(max_real, max_imag)*1.05
        
        return s_scale, G_scale

    def setup_plot(self):
        s_scale, G_scale = self.plot_scale
        
        # Setup s-domain plot
        self.ax1.set_xlim(-s_scale, s_scale)
        self.ax1.set_ylim(-s_scale, s_scale)
        self.ax1.grid(True, linestyle='--', alpha=0.6)
        # Add minor gridlines for higher density
        self.ax1.grid(True, which='minor', linestyle=':', alpha=0.3)
        self.ax1.minorticks_on()
        self.ax1.axhline(y=0, color='k', linestyle='-', alpha=0.3)
        self.ax1.axvline(x=0, color='k', linestyle='-', alpha=0.3)
        self.ax1.set_aspect('equal')
        
        # Setup G(s)-domain plot
        self.ax2.set_xlim(-G_scale, G_scale)
        self.ax2.set_ylim(-G_scale, G_scale)
        self.ax2.grid(True, linestyle='--', alpha=0.6)
        # Add minor gridlines for higher density
        self.ax2.grid(True, which='minor', linestyle=':', alpha=0.3)
        self.ax2.minorticks_on()
        self.ax2.axhline(y=0, color='k', linestyle='-', alpha=0.3)
        self.ax2.axvline(x=0, color='k', linestyle='-', alpha=0.3)
        self.ax2.set_aspect('equal')
        
        # Set only infinity ticks for both plots
        for ax, scale in [(self.ax1, s_scale), (self.ax2, G_scale)]:
            # Set only the extreme ticks
            ax.set_xticks([-scale, scale])
            ax.set_yticks([-scale, scale])
            
            # Label only the extreme ticks with infinity symbols
            ax.set_xticklabels(['-∞', '+∞'])
            ax.set_yticklabels(['-∞', '+∞'])
        
        self.ax1.set_title('s-domain plot')
        self.ax2.set_title('G(s)-domain plot')
        
        # Plot poles
        self.ax1.plot([p.real for p in self.tf.poles], [p.imag for p in self.tf.poles], 
                    'bx', markersize=10, label='Poles')
        
        if self.tf.zeros:  # Only plot if zeros exist
            self.ax1.plot([z.real for z in self.tf.zeros], [z.imag for z in self.tf.zeros], 
                         'bo', markersize=10, markerfacecolor='none', label='Zeros')
            
        if self.tf.zeros:
            self.ax1.legend()

        copyright_text = '© ' + str(datetime.now().year) + ' Andrea Covelli'
        for ax in [self.ax1, self.ax2]:
            ax.text(0.98, 0.02, copyright_text,
                    fontsize=8,
                    color='gray',
                    alpha=0.7,
                    transform=ax.transAxes,
                    horizontalalignment='right',
                    verticalalignment='bottom')

    def has_jw_axis_poles(self):
        # Check if any poles lie on the imaginary axis (including origin)
        return any(abs(p.real) < 1e-10 for p in self.poles)

    def setup_path(self):
        s_scale, _ = self.plot_scale
        R = s_scale  # Use s-domain scale for radius
        r = R * 0.05  # Detour radius as proportion of plot scale
        N_points = 1000  # Base number of points per segment
        N_points_curve = 1500  # More points for curved sections
        
        # Find imaginary axis poles (including origin)
        jw_poles = [p for p in self.tf.poles if abs(p.real) < 1e-10]
        jw_poles.sort(key=lambda x: x.imag)  # Sort by imaginary part
        
        path_segments = []
        
        # Start from origin
        current_y = 0
        
        # Special handling for origin pole
        if any(abs(p) < 1e-10 for p in self.tf.poles):
            # First quarter of semicircle around origin (270 to 360 degrees)
            theta = np.linspace(0, np.pi/2, N_points_curve)
            path_segments.append(r * np.exp(1j * theta))
            current_y = r
        
        # Go up positive imaginary axis with detours
        for pole in jw_poles:
            if pole.imag > 0:
                # Path to just before pole
                if current_y < pole.imag - r:
                    t = np.linspace(current_y, pole.imag - r, N_points)
                    path_segments.append(1j * t)
                
                # Detour around pole (right side)
                theta = np.linspace(-np.pi/2, np.pi/2, N_points_curve)
                detour = pole.imag + r * np.exp(1j * theta)
                path_segments.append(detour)
                
                current_y = pole.imag + r
        
        # Complete path to R*j
        if current_y < R:
            t = np.linspace(current_y, R, N_points)
            path_segments.append(1j * t)
        
        # Large semicircle at infinity
        theta = np.linspace(np.pi/2, -np.pi/2, N_points_curve)
        path_segments.append(R * np.exp(1j * theta))
        
        # Go back down negative imaginary axis with detours
        current_y = -R
        for pole in reversed(jw_poles):
            if pole.imag < 0:
                # Path to just before pole
                if current_y < pole.imag - r:
                    t = np.linspace(current_y, pole.imag - r, N_points)
                    path_segments.append(1j * t)
                
                # Detour around pole (right side)
                theta = np.linspace(-np.pi/2, np.pi/2, N_points_curve)
                detour = pole.imag + r * np.exp(1j * theta)
                path_segments.append(detour)
                
                current_y = pole.imag + r
        
        # Path to just before origin
        if current_y < -r:
            t = np.linspace(current_y, -r, N_points)
            path_segments.append(1j * t)
        
        # Complete the remaining quarter of semicircle around origin (270 to 360 degrees)
        if any(abs(p) < 1e-10 for p in self.tf.poles):
            theta = np.linspace(3*np.pi/2, 2*np.pi, N_points_curve)
            path_segments.append(r * np.exp(1j * theta))
        
        self.path = np.concatenate(path_segments)
        self.G_path = self.tf.evaluate(self.path)
        self.colors = plt.cm.rainbow(np.linspace(1, 0, len(self.path)))

    def setup_animation(self):
        self.scatter1 = self.ax1.scatter([], [], s=30)
        self.scatter2 = self.ax2.scatter([], [], s=30)
        self.arrow1 = self.ax1.quiver([], [], [], [], color='red', 
                                    scale=15,
                                    width=0.030,
                                    headwidth=6,
                                    headlength=8,
                                    headaxislength=7,
                                    alpha=0.7)
        self.arrow2 = self.ax2.quiver([], [], [], [], color='red', 
                                    scale=15,
                                    width=0.015,
                                    headwidth=6,
                                    headlength=8,
                                    headaxislength=7,
                                    alpha=0.7)
        
        self.anim = FuncAnimation(self.fig, self.animate, init_func=self.init,
                                frames=len(self.path), 
                                interval=self._get_interval(),  # Use dynamic interval
                                blit=True, repeat=False)
        self.anim_running = True

    def _get_interval(self):
        """Convert speed (1-100) to interval (50-1ms)"""
        return max(1, int(50 - (self.animation_speed - 1) * (49/99)))
    
    def update_speed(self, val):
        """Callback for speed slider"""
        self.animation_speed = val
        if self.anim_running:
            # Restart animation with new speed
            if hasattr(self.anim, 'event_source') and self.anim.event_source is not None:
                self.anim.event_source.stop()
            self.anim = FuncAnimation(self.fig, self.animate, init_func=self.init,
                                    frames=range(self.frame_num, len(self.path)), 
                                    interval=self._get_interval(),
                                    blit=True, repeat=False)

    # Rest of the methods remain the same as in your original code
    def init(self):
        self.scatter1.set_offsets(np.c_[[], []])
        self.scatter2.set_offsets(np.c_[[], []])
        self.arrow1.set_UVC([], [])
        self.arrow2.set_UVC([], [])
        return self.scatter1, self.scatter2, self.arrow1, self.arrow2

    def animate(self, frame):
        self.frame_num = frame
        skip = 10  # Increased skip rate for smoother animation
        frame = frame * skip

        if frame >= len(self.path) - 1:
            if self.anim_running:
                if hasattr(self.anim, 'event_source') and self.anim.event_source is not None:
                    self.anim.event_source.stop()
                self.anim_running = False
                self.btn_toggle.label.set_text('Start')
            return self.scatter1, self.scatter2, self.arrow1, self.arrow2
        
        # Use numpy array indexing for better performance
        idx = slice(0, frame+1, skip)
        current_path = self.path[idx]
        current_G = self.G_path[idx]
        current_colors = self.colors[idx]
        
        # Update scatter plots efficiently
        self.scatter1.set_offsets(np.c_[current_path.real, current_path.imag])
        self.scatter1.set_facecolors(current_colors)
        
        self.scatter2.set_offsets(np.c_[current_G.real, current_G.imag])
        self.scatter2.set_facecolors(current_colors)
        
        if frame > 0:
            # Calculate arrow directions more efficiently
            last_points = current_path[-2:]
            last_G = current_G[-2:]
            
            dx1 = last_points[-1].real - last_points[-2].real
            dy1 = last_points[-1].imag - last_points[-2].imag
            dx2 = last_G[-1].real - last_G[-2].real
            dy2 = last_G[-1].imag - last_G[-2].imag
            
            # Normalize vectors more efficiently
            mag1 = np.sqrt(dx1**2 + dy1**2)
            mag2 = np.sqrt(dx2**2 + dy2**2)
            
            if mag1 > 0:
                dx1, dy1 = dx1/mag1, dy1/mag1
            if mag2 > 0:
                dx2, dy2 = dx2/mag2, dy2/mag2
            
            # Update arrows
            self.arrow1.set_offsets(np.array([[current_path[-1].real, current_path[-1].imag]]))
            self.arrow1.set_UVC([dx1], [dy1])
            self.arrow2.set_offsets(np.array([[current_G[-1].real, current_G[-1].imag]]))
            self.arrow2.set_UVC([dx2], [dy2])
            
            self.arrow1.set_color(current_colors[-1])
            self.arrow2.set_color(current_colors[-1])
        
        return self.scatter1, self.scatter2, self.arrow1, self.arrow2

    def toggle_animation(self, event):
        if not self.anim_running:
            # Start animation
            if self.frame_num >= len(self.path) - 1:
                self.clear_animation(None)
                self.frame_num = 0
            
            # Create new animation starting from current frame
            self.anim = FuncAnimation(self.fig, self.animate, init_func=self.init,
                                    frames=range(self.frame_num, len(self.path)), 
                                    interval=self._get_interval(),  # Use current speed
                                    blit=True, repeat=False)
            self.anim_running = True
            self.btn_toggle.label.set_text('Stop')  # Change button text
        else:
            # Stop animation
            if hasattr(self.anim, 'event_source') and self.anim.event_source is not None:
                self.anim.event_source.stop()
            self.anim_running = False
            self.btn_toggle.label.set_text('Start')  # Change button text
    
    def clear_animation(self, event):
        if self.anim_running:
            self.anim.event_source.stop()
            self.anim_running = False
            self.btn_toggle.label.set_text('Start')
        self.frame_num = 0
        self.init()
        if hasattr(self, 'anim'):
            self.anim = None
        self.fig.canvas.draw_idle()

    def setup_buttons(self):
        self.btn_toggle.on_clicked(self.toggle_animation)
        self.btn_clear.on_clicked(self.clear_animation)
        self.speed_slider.on_changed(self.update_speed)

# Create and show the animation
animator = NyquistAnimator()
plt.subplots_adjust(left=0.1, right=0.9, top=0.9, bottom=0.15)
plt.show()