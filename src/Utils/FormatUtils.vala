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
public class FormatUtils {

    public const int SCORE_MILLION = 1000000;
    public const int SCORE_THOUSAND = 1000;
    public const int SCORE_ONE = 1;

    public static string FormatScore(int score, int denominator = SCORE_ONE) {
        var x = score / denominator;

        if(x >= SCORE_THOUSAND) 
            return FormatScore(score, SCORE_THOUSAND);
        if(x >= SCORE_MILLION)
            return FormatScore(score, SCORE_MILLION);

        var suffix = "";
        if(denominator == SCORE_ONE) suffix = "";
        else if(denominator == SCORE_THOUSAND) suffix = "k";
        else if(denominator == SCORE_MILLION) suffix = "M";
        else suffix = "B";

        return x.to_string() + suffix;
    }

}