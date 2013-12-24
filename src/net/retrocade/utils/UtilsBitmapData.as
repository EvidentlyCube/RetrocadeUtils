/*
 * Copyright (C) 2013 Maurycy Zarzycki
 * Unless stated otherwise in the rest of the source file
 *
 * Permission is hereby granted, free of charge, to any person obtaining
 * a copy of this software and associated documentation files (the "Software"),
 * to deal in the Software without restriction, including without limitation
 * the rights to use, copy, modify, merge, publish, distribute, sublicense,
 * and/or sell copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included
 * in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
 * OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
 * DEALINGS IN THE SOFTWARE.
 */

package net.retrocade.utils{
    import flash.display.BitmapData;
    import flash.display.IBitmapDrawable;
    import flash.geom.ColorTransform;
    import flash.geom.Matrix;
    import flash.geom.Point;
    import flash.geom.Rectangle;

    public class UtilsBitmapData{
        private static var POINT         :Point          = new Point();
        private static var MATRIX        :Matrix         = new Matrix();
        private static var RECT          :Rectangle      = new Rectangle();
        private static var COLORTRANSFORM:ColorTransform = new ColorTransform();

        /**
         * Returns a mirrored BitmapData, the original is unmodified
         * @param data BitmapData to be mirrored
         * @return New, mirrored BitmapData
         */
        public static function mirror(data:BitmapData):BitmapData{
            var m:Matrix = new Matrix();
            m.scale(-1, 1);
            m.translate(data.width, 0);

            var bitmapData:BitmapData = new BitmapData(data.width, data.height, true, 0);
            bitmapData.draw(data, m);

            return bitmapData;
        }

        public static function blit(source:BitmapData, target:BitmapData, x:uint, y:uint):void{
            POINT.x     = x;
            POINT.y     = y;

            target.copyPixels(source, source.rect, POINT, null, null, true);
        }

        public static function blitByRect(source:BitmapData, sourceRect:Rectangle, target:BitmapData, x:uint, y:uint):void{
            POINT.x     = x;
            POINT.y     = y;

            target.copyPixels(source, sourceRect, POINT, null, null, true);
        }

        /**
         * Blits a designated BitmapData's region to another BitmapData
         * @param source Source BitmapData
         * @param target Target BitmapData
         * @param x Target draw position
         * @param y Target draw position
         * @param sourceX X of the top-left corner of the source rectangle
         * @param sourceY Y of the top-left corner of the source rectangle
         * @param sourceWidth Width of the source rectangle
         * @param sourceHeight Height of the source rectangle
         */
        public static function blitPart(source:BitmapData, target:BitmapData, x:int, y:int, sourceX:uint, sourceY:uint,
                sourceWidth:uint, sourceHeight:uint):void{
            RECT.x      = sourceX;
            RECT.y      = sourceY;
            RECT.width  = sourceWidth;
            RECT.height = sourceHeight;

            POINT.x     = x;
            POINT.y     = y;

            target.copyPixels(source, RECT, POINT, null, null, true);
        }

        /**
         * Blits a rectangle on a given BitmapData
         * @param target BitmapData on which you want to draw the rectangle
         * @param x X position of the desired rectangle
         * @param y Y position of the desired rectangle
         * @param width Width of the desired rectangle
         * @param height Height of the desired rectangle
         * @param color RGBA color
         */
        public static function blitRectangle(target:BitmapData, x:uint, y:uint, width:uint, height:uint, color:uint = 0xFFFFFFFF):void{
            RECT.x      = x;
            RECT.y      = y;
            RECT.width  = width;
            RECT.height = height;

            target.fillRect(RECT, color);
        }

        /**
         * Applies a ColorTransform to a given BitmapData
         * @param data BitmapData to be colorized
         * @param redMulti
         * @param greenMulti
         * @param blueMulti
         * @param redOffset
         * @param greenOffset
         * @param blueOffset
         */
        public static function colorize(data:BitmapData, redMulti:Number, greenMulti:Number, blueMulti:Number, redOffset:int, greenOffset:int, blueOffset:int):void{
            COLORTRANSFORM = new ColorTransform(redMulti, greenMulti, blueMulti, 1, redOffset, greenOffset, blueOffset, 0);
            data.colorTransform(data.rect, COLORTRANSFORM);
        }

        public static function draw(source:IBitmapDrawable, target:BitmapData, x:int, y:int):void {
            MATRIX.identity();
            MATRIX.translate(x, y);
            target.draw(source, MATRIX);
        }

        public static function drawPart(source:IBitmapDrawable, target:BitmapData, x:int, y:int, sourceRect:Rectangle, blendMode:String = null):void{

            MATRIX.identity();
            MATRIX.translate(x - sourceRect.x, y - sourceRect.y);

            target.draw(source, MATRIX, null, blendMode, sourceRect);
        }

        public static function drawSpecial(source:*, target:BitmapData, x:int, y:int, rotation:Number = 0, scaleX:Number = 1, scaleY:Number = 1,
                alpha:Number = 1, blend:String = null, smoothing:Boolean = true,
                redMultiplier:Number = 1, greenMultiplier:Number = 1, blueMultiplier:Number = 1,
                redOffset:Number = 0, greenOffset:Number = 0, blueOffset:Number = 0, alphaOffset:Number = 0):void{
            MATRIX.identity();
            MATRIX.translate(-source.width / 2, -source.height / 2);
            MATRIX.rotate(rotation * Math.PI / 180);
            MATRIX.scale(scaleX, scaleY);
            MATRIX.translate(source.width / 2 + x, source.height / 2 + y);
            COLORTRANSFORM.redMultiplier   = redMultiplier;
            COLORTRANSFORM.blueMultiplier  = blueMultiplier;
            COLORTRANSFORM.greenMultiplier = greenMultiplier;
            COLORTRANSFORM.alphaMultiplier = alpha;
            COLORTRANSFORM.redOffset       = redOffset;
            COLORTRANSFORM.greenOffset     = greenOffset;
            COLORTRANSFORM.blueOffset      = blueOffset;
            COLORTRANSFORM.alphaOffset     = alphaOffset;

            target.draw(source, MATRIX, COLORTRANSFORM, blend, null, smoothing);

            COLORTRANSFORM.redOffset       = 0;
            COLORTRANSFORM.greenOffset     = 0;
            COLORTRANSFORM.blueOffset      = 0;
            COLORTRANSFORM.alphaOffset     = 0;
            COLORTRANSFORM.redMultiplier   = 1;
            COLORTRANSFORM.blueMultiplier  = 1;
            COLORTRANSFORM.greenMultiplier = 1;
            COLORTRANSFORM.alphaMultiplier = 1;
        }

        public static function shapeRectangle(data:BitmapData, x:uint, y:uint, w:uint, h:uint, color:uint, alpha:Number):void {
            RECT.x      = x;
            RECT.y      = y;
            RECT.width  = w;
            RECT.height = h;

            if (alpha < 0) alpha = 0
            else if (alpha > 1) alpha = 1;

            alpha = alpha * 255 | 0;

            color = (color & 0xFFFFFF) | (alpha << 24);

            data.fillRect(RECT, color);
        }
    }
}