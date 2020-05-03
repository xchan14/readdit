/*-
 * Copyright (c) 2017
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * You should have received a copy of the GNU General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 *
 * Authored by: Felipe Escoto <felescoto95@hotmail.com>
 *
 */

/*
Compile: valac --pkg gtk+-3.0 --pkg clutter-1.0 --pkg clutter-gst-3.0 --pkg clutter-gtk-1.0 VideoPlayer.vala
Usage: ./VideoPlayer file:///path/to/file.mp4
*/

public class Granite.Widgets.VideoPlayer : Gtk.EventBox {

    protected Clutter.Stage stage { get; private set; }
    protected Clutter.Actor video_actor { get; private set; }
    protected ClutterGst.Aspectratio aspect_ratio { get; private set; } 
    protected ClutterGst.Playback playback { get; private set; }

    protected GtkClutter.Embed clutter;

    private string video_uri_;
    public string? video_uri {
        get {
            return video_uri_;
        }

        set {
            stdout.printf ("Opening %s\n", value);
            if (value == null) {
                playback.uri = "";
            } else {
                playback.uri = value;
            }
        }
    }

    public bool playing {
        get {
            return playback.playing;
        }
    }

    public VideoPlayer() {
        stdout.printf("Instantiating VideoPlayer...\n");

        events |= Gdk.EventMask.POINTER_MOTION_MASK;
        events |= Gdk.EventMask.KEY_PRESS_MASK;
        events |= Gdk.EventMask.KEY_RELEASE_MASK;

        playback = new ClutterGst.Playback ();
        playback.set_seek_flags (ClutterGst.SeekFlags.ACCURATE);

        clutter = new GtkClutter.Embed ();
        clutter.use_layout_size = true;
        stage = (Clutter.Stage) clutter.get_stage ();
        stage.background_color = {0, 0, 0, 0};
        stage.user_resizable = true;
        //stage.set_minimum_size(300, 300);
        video_actor = new Clutter.Actor ();

        aspect_ratio = new ClutterGst.Aspectratio ();
        ((ClutterGst.Aspectratio) aspect_ratio).paint_borders = false;
        var gst_content = ((ClutterGst.Content) aspect_ratio);
        gst_content.player = playback;
        playback.audio_volume = 1.0;

        video_actor.content = aspect_ratio;

        video_actor.add_constraint (new Clutter.BindConstraint (stage, Clutter.BindCoordinate.WIDTH, 0));
        video_actor.add_constraint (new Clutter.BindConstraint (stage, Clutter.BindCoordinate.HEIGHT, 0));
    
        button_press_event.connect (on_button_press_event);

        stage.add_child (video_actor);

        add (clutter);
        show_all ();

        playback.get_pipeline().set_state(Gst.State.READY);
        stdout.printf("VideoPlayer instantiated...\n");
    }

    ~VideoPlayer() {
        button_press_event.disconnect(on_button_press_event);
        stop();
        playback.get_pipeline().get_bus().unref();
        playback.get_pipeline().set_state(Gst.State.NULL);
        clutter = null;
        video_actor = null;
        playback = null;
        stdout.printf("VideoPlayer is disposed...\n");
    }

    public double get_progress () {
        return playback.progress;
    }

    public void seek_jump_seconds (int seconds) {
        var duration = playback.duration;
        var progress = playback.progress;
        var new_progress = ((duration * progress) + (double) seconds) / duration;
        playback.progress = double.min (new_progress, 1.0);
    }

    public void play() {
        stdout.printf("Video is playing...\n");
        playback.playing = true;
    }

    public void stop() {
        if(playback.playing) {
            stdout.printf("Video stops playing...\n");
            playback.playing = false;
        }
    }

    private bool on_button_press_event(Gdk.EventButton event) {
        if (event.button == Gdk.BUTTON_SECONDARY) {
            if(playing) {
                stop();
            } else {
                play();
            }
        }
        return base.button_press_event(event);
    }
}
