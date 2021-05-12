{
 /***************************************************************************
                               wclstrconsts.pas
                               ----------------

                   Initial Revision : Mon Jan 13 CST 2020

 ***************************************************************************/

 *****************************************************************************
  This file is part of the Web Component Library (WCL)

  See the file COPYING.modifiedLGPL.txt, included in this distribution,
  for details about the license.
 *****************************************************************************
}
unit WCLStrConsts;

{$mode objfpc}{$H+}

interface

const
  // Constants for WebSocket close codes
  WS_NORMAL_CLOSURE         = 1000;
  WS_GOING_AWAY             = 1001;
  WS_PROTOCOL_ERROR         = 1002;
  WS_UNSUPPORTED_DATA       = 1003;
  WS_NO_STATUS_RECEIVED     = 1005;
  WS_ABNORMAL_CLOSURE       = 1006;
  WS_INVALID_FRAME_PAYLOAD  = 1007;
  WS_POLICY_VIOLATION       = 1008;
  WS_MESSAGE_TOO_BIG        = 1009;
  WS_MANDATORY_EXT          = 1010;
  WS_INTERNAL_SERVER_ERROR  = 1011;
  WS_BAD_TLS_HANDSHAKE      = 1015;

resourcestring
  rsFormResourceSNotFoundForResourcelessFormsCreateNew = 'Form resource %s '
    +'not found. For resourceless forms CreateNew constructor must be used.';
  rsFormStreamingError = 'Form streaming "%s" error: %s';
  rsFileButtonNoFileSelected = 'No file selected';
  rsResourceNotFound = 'Resource not found: %s';
  rsErrUncaughtException = 'Uncaught exception of type %s: ' + LineEnding + LineEnding + '%s';
  rsErrUncaughtObject = 'Uncaught exception of type %s.';
  rsNoTimers = 'No more timers available.';

  rsFixedColsTooBig = 'Too many fixed columns.';
  rsFixedRowsTooBig = 'Too many fixed rows.';
  // String constants for WebSocket close codes
  wsNormalClosure = 'Normal Closure';
  wsGoingAway = 'Going Away';
  wsProtocolError = 'Protocol error';
  wsUnsupportedData = 'Unsupported Data';
  wsNoStatusRcvd = 'No Status Rcvd';
  wsAbnormalClosure = 'Abnormal Closure';
  wsInvalidFramePayload = 'Invalid frame payload data';
  wsPolicyViolation = 'Policy Violation';
  wsMessageTooBig = 'Message Too Big';
  wsMandatoryExt = 'Mandatory Ext.';
  wsInternalServerErorr = 'Internal Server Error';
  wsTLSHandshake = 'TLS handshake';

implementation

end.

