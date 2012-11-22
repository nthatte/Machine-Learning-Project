%Author: Aravindh Mahendran
%Caculate the texton histogram on training images using the ground truth as segments
filenames = dir('/media/Data/dropbox/documents/course_work/fall12_10701/course_project/Train/labels/');
load TextonLibrary.mat TextonLibrary;
load fb.mat fb;
dictionarysize = size(TextonLibrary, 1);
total_number_of_segments_in_dataset = 0;
for i=3:size(filenames,1) %Avoid the . and .. in the filenames vector
    i
    name = filenames(i).name(1:end-7);
    I = imread(['/media/Data/dropbox/documents/course_work/fall12_10701/course_project/Train/images/' name '.bmp']);
    Iseg = imread(['/media/Data/dropbox/documents/course_work/fall12_10701/course_project/Train/labels/' name '_GT.bmp']);
    [textonmap, confmap] = compute_textons(I, fb, TextonLibrary);
    Iseggray = rgb2gray(Iseg);
    v = unique(Iseggray(:));
    image_segment_textonhists = zeros(size(v,1), dictionarysize);
    image_segment_labels = zeros(size(v,1),1);
    total_number_of_segments_in_dataset = total_number_of_segments_in_dataset + size(v,1);
    for j=1:size(v,1)
        %jth segment
        mask = (Iseggray == v(j));
        segment_textons = textonmap(mask);
        image_segment_textonhists(j,:) = hist(segment_textons, 1:dictionarysize);
        image_segment_textonhists(j,:) = image_segment_textonhists(j,:) / sum(image_segment_textonhists(j,:));
        image_segment_labels(j,1) = getLabelFromGT(Iseg, mask);
    end
    destination_filename = ['/media/Data/dropbox/documents/course_work/fall12_10701/course_project/Train/segment_textonhists/' name '_TH.mat'];
    save(destination_filename, 'image_segment_textonhists', 'image_segment_labels');
    'written'
end
trainingHistogramMatrix = zeros(total_number_of_segments_in_dataset, dictionarysize);
trainingLabelVector = zeros(total_number_of_segments_in_dataset, 1);
counter = 1;
for i=3:size(filenames, 1)
    i
    name = filenames(i).name(1:end-7);
    histogram_filename = ['/media/Data/dropbox/documents/course_work/fall12_10701/course_project/Train/segment_textonhists/' name '_TH.mat'];
    load(histogram_filename, 'image_segment_textonhists', 'image_segment_labels');
    trainingHistogramMatrix(counter:(counter + size(image_segment_textonhists,1) - 1), :) = image_segment_textonhists;
    trainingLabelVector(counter:(counter + size(image_segment_textonhists,1) - 1), :) = image_segment_labels;
    counter = counter + size(image_segment_textonhists,1);
end
save('trainingHistogramMatrix.mat', trainingHistogramMatrix);
save('trainingLabelVector.mat', trainingLabelVector);
