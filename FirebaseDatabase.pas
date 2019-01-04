(*
  Created by Yakup ULUTAÞ
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

//const
//  ApiURL = 'https://kidstube-d3847.firebaseio.com/videos.json?auth=';
//  ApiKey = 'QcdqobbEoSHyEwkeoh2mfdjW6Brky3eHR5Qe0GX5';

 type

  TFirebaseDatabase = class(TObject)
  private
    FKoleksiyon: String;
    FApiURL: String;
    FApiKey: String;
    procedure SetApiURL(const Value: String);
    procedure SetKoleksiyon(const Value: String);
    procedure SetApiKey(const Value: String);
   public
     property ApiURL  : String read FApiURL write SetApiURL;
     property ApiKey  : String read FApiKey write SetApiKey;
     property Koleksiyon  : String read FKoleksiyon write SetKoleksiyon;
     function Save(JsonObject:TJsonObject)  : String;
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
  PostUrl      : String;
begin
  if not Assigned(JsonObject) then
      raise Exception.Create('JsonObject Not Null');

  PostUrl := FApiURL + FKoleksiyon + '.json?auth=' + FApiKey;
  Response  := TMemoryStream.Create;
  Request   := TclHttpRequest.Create(nil);
  SStream   := TStringStream.Create(JsonObject.ToJSON);
  FireBase  := TclHttp.Create(nil);
  try
    Request.RequestStream        := SStream;
    Request.Header.ContentType   := 'application/json';
    Request.Header.ContentLength := IntToStr(SStream.Size);
    FireBase.TimeOut := 5000;
    FireBase.post(PostUrl, Request, Response);
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

procedure TFirebaseDatabase.SetApiKey(const Value: String);
begin
  FApiKey := Value;
end;

procedure TFirebaseDatabase.SetApiURL(const Value: String);
begin
  FApiURL := Value;
end;

procedure TFirebaseDatabase.SetKoleksiyon(const Value: String);
begin
  FKoleksiyon := Value;
end;

end.
