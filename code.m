% Load the pretrained Tiny YOLOv2 object detection network
model = 'tiny-yolov2-coco';
detector = yolov2ObjectDetector(model);

% Create a video file reader to read video frames
videoFile = 'tigerv.mp4'; % Replace with the path to your video file
videoReader = VideoReader(videoFile);

% Create a video player for visualization
videoPlayer = vision.DeployableVideoPlayer('Name', 'Object Detection');

% Process each frame of the video
while hasFrame(videoReader)
    % Read the current video frame
    frame = readFrame(videoReader);

    % Perform object detection on the current frame
    [bboxes, scores, labels] = detect(detector, frame);

    % Annotate detected objects
    if ~isempty(bboxes)
        for i = 1:size(bboxes, 1)
            bbox = bboxes(i, :);
            score = scores(i);
            label = labels(i);

            % Draw bounding box
            frame = insertObjectAnnotation(frame, 'rectangle', bbox, ...
                sprintf('%s: %.2f', label, score), 'Color', 'green', 'LineWidth', 2);
        end
    end

    % Display the annotated frame
    step(videoPlayer, frame);
end

% Release the video player
release(videoPlayer);
