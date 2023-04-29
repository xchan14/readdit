
/*
* Copyright (c) 2020 Christian Camilon 
*
* This program is free software; you can redistribute it and/or
* modify it under the terms of the GNU General Public
* License as published by the Free Software Foundation; either
* version 2 of the License, or (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
* General Public License for more details.
*
* You should have received a copy of the GNU General Public
* License along with this program; if not, write to the
* Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
* Boston, MA 02110-1301 USA
*
* Authored by: Christian Camilon <christiancamilon@gmail.com>
*/
using Gdk;

public class Readdit.Utils.ImageUtils {

    public static Pixbuf CropToSquare(Pixbuf original_image, int size = 100) {
        // Calculate the new dimensions for the cropped image
        int width = original_image.get_width();
        int height = original_image.get_height();
        int x_offset = 0;
        int y_offset = 0;
        
        if (width > height) {
            x_offset = (width - height) / 2;
            width = height;
        } else {
            y_offset = (height - width) / 2;
            height = width;
        }
        
        // Crop the image
        Pixbuf cropped_image = new Pixbuf.subpixbuf(original_image, x_offset, y_offset, width, height);
            
        // Scale the image to the desired size
        Pixbuf scaled_image = cropped_image.scale_simple(size, size, InterpType.BILINEAR);

        return scaled_image;
    }

}