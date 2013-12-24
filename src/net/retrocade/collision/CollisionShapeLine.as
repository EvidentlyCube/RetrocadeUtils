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

/**
 * Created by Skell on 09.11.13.
 */
package net.retrocade.collision {
    public class CollisionShapeLine extends CollisionShapeBase{
        private var _endX:Number;
        private var _endY:Number;

        public function get right():Number{
            return _x + _endX;
        }

        public function get bottom():Number{
            return _y + _endY;
        }

        public function get endX():Number {
            return _endX;
        }

        public function set endX(value:Number):void {
            _endX = value;
        }

        public function get endY():Number {
            return _endY;
        }

        public function set endY(value:Number):void {
            _endY = value;
        }

        override public function get shapeType():CollisionShapeType {
            return CollisionShapeType.LINE;
        }

        override public function collide(shape:CollisionShapeBase):Boolean {
            switch(shape.shapeType){
                case(CollisionShapeType.CIRCLE):
                    return CollisionManager.shapesCircleLine(shape as CollisionShapeCircle, this);

                case(CollisionShapeType.LINE):
                    return CollisionManager.shapesLineLine(shape as CollisionShapeLine, this);

                default:
                    throw new Error("Unknown shape type");
            }
        }

        public function CollisionShapeLine(x:Number = 0, y:Number = 0, endX:Number = 0, endY:Number = 0) {
            super(x, y);

            _endX = endX;
            _endY = endY;
        }
    }
}
