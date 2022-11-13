     /**
      * This file is part of i5/OS Programmer's Toolkit.
      *
      * Copyright (C) 2010, 2011  Junlei Li.
      *
      * i5/OS Programmer's Toolkit is free software: you can redistribute it and/or modify
      * it under the terms of the GNU General Public License as published by
      * the Free Software Foundation, either version 3 of the License, or
      * (at your option) any later version.
      *
      * i5/OS Programmer's Toolkit is distributed in the hope that it will be useful,
      * but WITHOUT ANY WARRANTY; without even the implied warranty of
      * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
      * GNU General Public License for more details.
      *
      * You should have received a copy of the GNU General Public License
      * along with i5/OS Programmer's Toolkit.  If not, see <http://www.gnu.org/licenses/>.
      */

     /**
      * @file t121a.rpgle
      *
      * Used by t121.rpgle.
      */
      /if defined(*crtbndrpg)
     h dftactgrp(*no) actgrp('T121A')
      /endif

     /**
      * It's necessary to declare nail_str and i_static in a DS
      * so that the RPG compiler will allocated them next to
      * each other.
      */
      * exported static var
     d eee             ds                  export
     d estr                          16a   inz('export me')
     d eint                          10u 0 inz(7)
      * common rpg static var
     d                 ds
     d cstr                          16a   inz('All good wishes')
     d cint                          10u 0 inz(7)

     d func            pr

     c                   eval      cint += 1
     c                   eval      eint += 1
     c                   callp     func()
     c                   seton                                        lr

     p func            b
      * local static var
     d                 ds                  static
     d lstr                          16a   inz('local one')
     d lint                          10u 0 inz(7)

     c                   eval      lint += 1
     p func            e
