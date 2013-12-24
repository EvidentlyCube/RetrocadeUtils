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
    public class CollisionShapeCircle extends CollisionShapeBase{
        private var _radius:Number;

        public function get radius():Number {
            return _radius;
        }

        override public function collide(shape:CollisionShapeBase):Boolean {
            switch(shape.shapeType){
                case(CollisionShapeType.CIRCLE):
                    return CollisionManager.shapesCircleCircle(this, shape as CollisionShapeCircle);
                case(CollisionShapeType.RECTANGLE):
                    return CollisionManager.shapesCircleRectangle(this, shape as CollisionShapeRectangle);
                case(CollisionShapeType.LINE):
                    return CollisionManager.shapesCircleLine(this, shape as CollisionShapeLine);
                default:
                    throw new Error("Unknown shape type");
            }
        }

        public function set radius(value:Number):void {
            _radius = value;
        }

        override public function get shapeType():CollisionShapeType {
            return CollisionShapeType.CIRCLE;
        }

        public function CollisionShapeCircle(x:Number = 0, y:Number = 0, radius:Number = 0) {
            super(x, y);
            _radius = radius;
        }
    }
}
