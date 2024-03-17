-- Task 1
CREATE TABLE Apartments (
    apartment_id int identity primary key,
    node hierarchyid,
    level as node.GetLevel() persisted,
    day_cost money not null,
    room_number int not null,
    house_number nvarchar(10) not null,
    street nvarchar(50) not null,
    city nvarchar(30) not null,
    number_of_rooms int not null,
    description nvarchar(max)
);

INSERT INTO Apartments (node, day_cost, room_number, house_number, street, city, number_of_rooms, description)
VALUES (hierarchyid::GetRoot(), 10, 423, 25, 'Peshkov', 'Minsk', 4, N'Четырёхкомнатная квартира');

DECLARE @ThreeRoomApartmentNode hierarchyid;
DECLARE @Level hierarchyid;
SELECT @ThreeRoomApartmentNode = node FROM Apartments WHERE apartment_id = 3;
INSERT INTO Apartments (node, day_cost, room_number, house_number, street, city, number_of_rooms, description)
VALUES (@ThreeRoomApartmentNode.GetDescendant(NULL, NULL), 8, 425, 25, 'Peshkov', 'Minsk', 3, N'Трёхкомнатная квартира');

DECLARE @ThreeRoomApartmentNode hierarchyid;
DECLARE @Level hierarchyid;
SELECT @Level = node FROM Apartments WHERE apartment_id = 5;
SELECT @ThreeRoomApartmentNode = node FROM Apartments WHERE apartment_id = 3;
INSERT INTO Apartments (node, day_cost, room_number, house_number, street, city, number_of_rooms, description)
VALUES (@ThreeRoomApartmentNode.GetDescendant(@Level, NULL), 8, 426, 25, 'Peshkov', 'Minsk', 2, N'Двухкомнатная квартира');

DECLARE @Level hierarchyid;
SELECT @Level = node FROM Apartments WHERE apartment_id = 5;
INSERT INTO Apartments (node, day_cost, room_number, house_number, street, city, number_of_rooms, description)
VALUES (@Level.GetDescendant(NULL, NULL), 3, 427, 25, 'Peshkov', 'Minsk', 1, N'Однокомнатная квартира');


SELECT node.ToString() AS NodeAsString,
       node as NodeAsBinary,
       node.GetLevel() AS level,
       apartment_id,
       description,
       day_cost FROM Apartments;



-- Task 2
CREATE PROCEDURE GetSubordinates @node hierarchyid
AS
BEGIN
    WITH SubordinatesCTE AS (
        SELECT node, apartment_id, level = 1
        FROM Apartments
        WHERE node = @node

        UNION ALL

        SELECT A.node, A.apartment_id, S.level + 1
        FROM Apartments A
        JOIN SubordinatesCTE S ON A.node.GetAncestor(1) = S.node
    )

    SELECT node.ToString() AS node_path, apartment_id, level
    FROM SubordinatesCTE
    ORDER BY node;
END;

DECLARE @nodeToSearch hierarchyid
SET @nodeToSearch = '/1/1/'
EXEC GetSubordinates @nodeToSearch;

-- Task 3
CREATE  PROCEDURE AddNode
    @ParentNodePath hierarchyid
AS
BEGIN

    DECLARE @LastChild hierarchyid;

    SELECT TOP 1 @LastChild = node
    FROM Apartments
    WHERE node.GetAncestor(1) = @ParentNodePath
    ORDER BY node DESC;

    DECLARE @NewNodePath hierarchyid;
    SET @NewNodePath = @ParentNodePath.GetDescendant(@LastChild, NULL);

    INSERT INTO Apartments (day_cost, room_number, house_number, street, city, number_of_rooms, description, node)
    VALUES (12, 2, '12', 'New st.', 'Minsk', 12, N'Студия', @NewNodePath);
END;

DECLARE @ParentNodePath hierarchyid;
SET @ParentNodePath = hierarchyid::Parse('/');

-- Task 4
CREATE OR ALTER PROCEDURE MOVE_NODE
            @OLD_PARENT_NODE HIERARCHYID,
            @NEW_PARENT_NODE HIERARCHYID
        AS
        BEGIN
            DECLARE @HID_DESCENDANT hierarchyid;
            DECLARE @HID_NEW hierarchyid;
            DECLARE @NodeToMove HIERARCHYID;
            DECLARE @ChildId HIERARCHYID;
            DECLARE @NewId HIERARCHYID;
            DECLARE CURSOR_DESCENDANT CURSOR FOR
                SELECT node
                FROM Apartments
                WHERE node.GetAncestor(1) = @OLD_PARENT_NODE;

            OPEN CURSOR_DESCENDANT;
            FETCH NEXT FROM CURSOR_DESCENDANT INTO @HID_DESCENDANT;
            WHILE @@FETCH_STATUS = 0
                BEGIN
                    DECLARE @Retry INT = 0;
                    DECLARE @MaxRetry INT = 3;
                    WHILE @Retry < @MaxRetry
                        BEGIN
                            BEGIN TRY
                                SELECT @HID_NEW = @NEW_PARENT_NODE.GetDescendant(MAX(node), NULL)
                                FROM Apartments
                                WHERE node.GetAncestor(1) = @NEW_PARENT_NODE;
                                UPDATE Apartments
                                SET node = node.GetReparentedValue(@HID_DESCENDANT, @HID_NEW)
                                WHERE node.IsDescendantOf(@HID_DESCENDANT) = 1;
                                BREAK;
                            END TRY
                            BEGIN CATCH
                                SET @Retry += 1;

                                IF @Retry = @MaxRetry
                                    BEGIN
                                        THROW;
                                    END;
                            END CATCH;
                        end
                    FETCH NEXT FROM CURSOR_DESCENDANT INTO @HID_DESCENDANT;
                end
            CLOSE CURSOR_DESCENDANT;
            DEALLOCATE CURSOR_DESCENDANT;

        end;

EXECUTE MOVE_NODE @oldParentNode = '/1/', @newParentNode = '/2/1/';