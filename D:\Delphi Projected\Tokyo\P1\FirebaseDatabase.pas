(*
  Created by Yakup ULUTAŞ
  https://firebase.google.com/docs/database/rest/save-data
*)

unit FirebaseDatabase;

interface

uses
  system.json,
  System.Classes,
  clHttp,
  clHttpRequest,
  System.SysUtils;

const
  ApiURL = 'https://projectname.firebaseio.com/tablename.json?auth=';
  ApiKey = 'QcdqoxxxxxxxxxxxxxxxxxxxxxxxxxxxxxQe0GX5';

 type

  TFirebaseDatabase = class(TObject)


   public
     function Save(JsonObject:TJsonObject):String;
  end;


implementation

{ TFirebaseDatabase }

function TFirebaseDatabase.Save(JsonObject: TJsonObject): String;
var
  SStream      : TStringStream;
  Response     : TMemoryStream;
  ResponseData : Tstringlist;
  Request      : TclHttpRequest;
  FireBase     : TclHttp;
  ResultObject : TJsonObject;
begin
  if not Assigned(JsonObject) then
      raise Exception.Create('JsonObject Not Null');

  Response  := TMemoryStream.Create;
  Request   := TclHttpRequest.Create(nil);
  SStream   := TStringStream.Create(JsonObject.ToJSON);
  FireBase  := TclHttp.Create(nil);
  try
    Request.RequestStream        := SStream;
    Request.Header.ContentType   := 'application/json';
    Request.Header.ContentLength := IntToStr(SStream.Size);

    FireBase.TimeOut := 5000;
    FireBase.post(ApiURL + apikey, Request, Response);
    Response.Position := 0;

    ResponseData  := Tstringlist.Create;
    ResponseData.LoadFromStream(Response, TEncoding.UTF8);

        ResultObject := TJSONObject.ParseJSONValue(ResponseData.Text) as TJSONObject;
        try
          Result := ResultObject.Get('name').JsonValue.Value;
        finally
          if Assigned(ResultObject) then
            FreeAndNil(ResultObject);
        end;

  finally
    if Assigned(ResponseData) then
      FreeAndNil(ResponseData);

    if Assigned(Response) then
      FreeAndNil(Response);

    if Assigned(Request) then
      FreeAndNil(Request);

    if Assigned(SStream) then
      FreeAndNil(SStream);

    if Assigned(FireBase) then
      FreeAndNil(FireBase);
  end;
end;

end.
