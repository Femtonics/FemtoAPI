classdef (ConstructOnLoad) MexEventData < event.EventData
   properties
      jsonString
   end
   
   methods
      function data = MexEventData(newJsonString)
         data.jsonString = newJsonString;
      end
   end
end