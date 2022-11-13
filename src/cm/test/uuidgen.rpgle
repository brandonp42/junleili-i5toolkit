     /**
      * @file uuidgen
      *
      * returns UUID in character format.
      */
     h bnddir('QC2LE') dftactgrp(*no)

      /copy mih52
     d i_main          pr                  extpgm('UUIDGEN')
     d     uuid                      32a

     d cvthc           pr                  extproc('cvthc')
     d     receiver                    *   value
     d     source                      *   value
     d     nibbles                   10i 0 value

     d id              ds                  likeds(uuid_t)

     d i_main          pi
     d     uuid                      32a

      /free
           id.bytes_in = 32;
           genuuid(id);
           cvthc(%addr(uuid) : %addr(id.rtn_uuid) : 32);

           *inlr = *on;
      /end-free
