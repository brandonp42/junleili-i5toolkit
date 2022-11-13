     /**
      * @file t148.rpgle
      *
      * Test of _MATPG. ODT analysis (scalar data objects).
      */
     h dftactgrp(*no) bnddir('UANDI')

     fQSYSPRT   o    f  132        disk

      /copy mih52
      /copy uandi

     d pep             pr                  extpgm('T148')
     d     pgm_name                  10a

     d parse_odt       pr
     d                                 *   value

     d rcv             ds                  likeds(matpg_tmpl_t)
     d                                     based(bufptr)
     d bufptr          s               *
     d len             s             10i 0
      * OPM MI program
     d pgm             s               *
     d odv_ptr         s               *
     d oes_ptr         s               *
     d odv_len         s             10u 0 based(odv_ptr)
     d i               s             10i 0
     d summary         s             80a
     d attr_name       s             50a
     d attr_value      s             30a

     d pep             pi
     d     pgm_name                  10a

      /free

           rslvsp_tmpl.obj_type = x'0201';
           rslvsp_tmpl.obj_name = pgm_name;
           rslvsp2(pgm : rslvsp_tmpl);

           len = 8;
           bufptr = modasa(len);
           rcv.bytes_in = len;
           matpg(rcv : pgm);

           len = rcv.bytes_out;
           bufptr = modasa(len);
           rcv.bytes_in = len;
           matpg(rcv : pgm);
             // check rcv

           odv_ptr = bufptr + rcv.odv_offset;
           oes_ptr = bufptr + rcv.oes_offset;

           summary = 'Program name                  '
                     + pgm_name;
           except SUMREC;
           summary = 'Length of ODV component       '
                     + %char(odv_len);
           except SUMREC;
           odv_ptr += 4;
           for i = 1 to rcv.num_odv1;
               summary = 'ODT index                     ' + %char(i);
               except SUMREC;
               parse_odt(odv_ptr);
               odv_ptr += 4;
           endfor;

           *inlr = *on;
      /end-free

      * data object attribute
     oQSYSPRT   e            ATREC
     o                       attr_name
     o                       attr_value

      * summary
     oQSYSPRT   e            SUMREC
     o                       summary

     p parse_odt       b
     d parse_odt       pi
     d     odv_ptr                     *   value

     d odve            ds                  based(odv_ptr)
     d                                     likeds(odv_entry_t)

     d flag2           s              5u 0
     d flag4           s             10u 0
     d grp_1           s               n   inz(*on)

      /free

           // type of the data object
           flag2 = cvt_bits2(odve.hi : 2 : 0 : 4);
           select;
           when flag2 = 0;       // b'0000', group-1 scalar
               grp_1 = *on;
           when flag2 = 9;       // b'1001', group-2 scalar
               grp_1 = *off;
           other;
               return;
           endsl;

           attr_name = 'Object type';
           attr_value = 'Scalar';
           except ATREC;

           // addr type
           attr_name = 'Addressability type';
           flag2 = cvt_bits2(odve.hi : 2 : 5 : 3);
           select;
           when flag2 = 0;
               attr_value = 'Direct static';
           when flag2 = 1;
               attr_value = 'Direct Automatic';
           when flag2 = 2;
               attr_value = 'Based';
           when flag2 = 3;
               attr_value = 'Defined';
           when flag2 = 4;
               attr_value = 'Parameter';
           when flag2 = 5;
               attr_value = 'Based on PCO';
           other;
               attr_value = 'Oops!';
           endsl;
           except ATREC;

           // scalar type
           attr_name = 'Scalar type';
           if not grp_1;
               attr_value = 'Unsigned binary';
           else;
               flag2 = cvt_bits2(odve.hi : 2 : 13 : 3);
               select;
                   when flag2 = 0;
                       attr_value = 'Signed binary';
                   when flag2 = 1;
                       attr_value = 'Floating-point';
                   when flag2 = 2;
                       attr_value = 'Zoned decimal';
                   when flag2 = 3;
                       attr_value = 'Packed decimal';
                   when flag2 = 4;
                       attr_value = 'Character string';
                   other;
                       attr_value = 'Oops!';
               endsl;
           endif;
           except ATREC;

           // boundary attr
           attr_name = 'Boundary';
           flag2 = cvt_bits2(odve.hi : 2 : 9 : 3);
           select;
           when flag2 = 0;
               attr_value = 'None';
           when flag2 = 1;
               attr_value = '2';
           when flag2 = 2;
               attr_value = '4';
           when flag2 = 3;
               attr_value = '8';
           when flag2 = 4;
               attr_value = '16';
           endsl;
           except ATREC;

      /end-free
     p parse_odt       e
